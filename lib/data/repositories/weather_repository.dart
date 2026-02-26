import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/data/models/weather_data.dart';
import 'package:oneday/data/services/weather_service.dart';

class WeatherRepository {
  final WeatherService _service;

  WeatherData? _cachedWeather;
  List<Map<String, dynamic>>? _cachedForecast;
  Map<String, dynamic>? _cachedDaily;
  DateTime? _cacheTime;
  double? _cachedLat;
  double? _cachedLon;

  WeatherRepository(this._service);

  bool _isCacheValidFor(double lat, double lon) {
    if (_cachedWeather == null || _cacheTime == null) return false;
    if (DateTime.now().difference(_cacheTime!) >= AppConfig.weatherCacheDuration) return false;
    if (_cachedLat == null || _cachedLon == null) return false;
    final moved = (lat - _cachedLat!).abs() >= 0.01 || (lon - _cachedLon!).abs() >= 0.01;
    return !moved;
  }

  bool _isForecastCacheValidFor(double lat, double lon) {
    if (_cachedForecast == null || _cachedDaily == null || _cacheTime == null) return false;
    if (DateTime.now().difference(_cacheTime!) >= AppConfig.weatherCacheDuration) return false;
    if (_cachedLat == null || _cachedLon == null) return false;
    final moved = (lat - _cachedLat!).abs() >= 0.01 || (lon - _cachedLon!).abs() >= 0.01;
    return !moved;
  }

  /// Open-Meteo 응답에서 오늘/내일 인덱스 찾기
  int? _findDateIndex(Map<String, dynamic> daily, int daysFromToday) {
    final times = (daily['time'] as List?)?.cast<String>();
    if (times == null) return null;
    final now = DateTime.now();
    // Duration.add 사용으로 월말 오버플로우 방지
    final today = DateTime(now.year, now.month, now.day);
    final target = today.add(Duration(days: daysFromToday));
    final targetStr =
        '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';
    final idx = times.indexOf(targetStr);
    return idx >= 0 ? idx : null;
  }

  Future<WeatherData> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    if (_isCacheValidFor(lat, lon)) return _cachedWeather!;

    final currentJson = await _service.fetchCurrentWeather(lat: lat, lon: lon);

    // OWM 3h 예보 (강수 확률용)
    List<Map<String, dynamic>>? forecastList;
    try {
      final forecastJson = await _service.fetchForecast(lat: lat, lon: lon);
      final rawList = forecastJson['list'] as List?;
      if (rawList != null) {
        forecastList = rawList.cast<Map<String, dynamic>>();
        _cachedForecast = forecastList;
      }
    } catch (_) {
      // forecast fetch failed, proceed without forecast data
    }

    // Open-Meteo 일별 최고/최저 + 현재 기온 + UV (정확한 고해상도 모델)
    double? todayTempMax;
    double? todayTempMin;
    double? currentTempOverride;
    double? feelsLikeOverride;
    double? uvIndexOverride;
    try {
      final dailyJson = await _service.fetchDailyForecast(lat: lat, lon: lon);
      _cachedDaily = dailyJson;

      // 현재 기온 (Open-Meteo current — 기상청 동일 모델, OWM보다 정확)
      final current = dailyJson['current'] as Map<String, dynamic>?;
      if (current != null) {
        currentTempOverride = (current['temperature_2m'] as num?)?.toDouble();
        feelsLikeOverride = (current['apparent_temperature'] as num?)?.toDouble();
      }

      final daily = dailyJson['daily'] as Map<String, dynamic>?;
      if (daily != null) {
        final idx = _findDateIndex(daily, 0);
        if (idx != null) {
          final maxList = (daily['temperature_2m_max'] as List?)?.cast<num>();
          final minList = (daily['temperature_2m_min'] as List?)?.cast<num>();
          final uvList = (daily['uv_index_max'] as List?)?.cast<num>();
          todayTempMax = maxList?[idx].toDouble();
          todayTempMin = minList?[idx].toDouble();
          uvIndexOverride = uvList?[idx].toDouble();
        }
      }
    } catch (_) {
      // Open-Meteo daily fetch failed, proceed without daily data
    }

    _cachedWeather = WeatherData.fromOwm(
      currentJson: currentJson,
      forecastJson: forecastList?.isNotEmpty == true ? forecastList!.first : null,
      todayTempMax: todayTempMax,
      todayTempMin: todayTempMin,
      currentTempOverride: currentTempOverride,
      feelsLikeOverride: feelsLikeOverride,
      uvIndexOverride: uvIndexOverride,
    );
    _cacheTime = DateTime.now();
    _cachedLat = lat;
    _cachedLon = lon;
    return _cachedWeather!;
  }

  Future<DailyForecast> fetchTomorrowForecast({
    required double lat,
    required double lon,
  }) async {
    // Open-Meteo 캐시 사용 (없거나 위치 이동 시 새로 요청)
    Map<String, dynamic>? dailyJson;
    List<Map<String, dynamic>>? forecastList;

    if (_isForecastCacheValidFor(lat, lon)) {
      dailyJson = _cachedDaily;
      forecastList = _cachedForecast;
    } else {
      // 위치가 바뀌었거나 캐시 만료 → 새로 요청
      try {
        dailyJson = await _service.fetchDailyForecast(lat: lat, lon: lon);
        _cachedDaily = dailyJson;
      } catch (_) {
        dailyJson = _cachedDaily; // 실패 시 기존 캐시라도 사용
      }

      try {
        final forecastJson = await _service.fetchForecast(lat: lat, lon: lon);
        final rawList = forecastJson['list'] as List?;
        if (rawList != null) {
          forecastList = rawList.cast<Map<String, dynamic>>();
          _cachedForecast = forecastList;
        }
      } catch (_) {
        forecastList = _cachedForecast;
      }

      // 내일 예보 전용 캐시 시간/위치 갱신
      _cacheTime = DateTime.now();
      _cachedLat = lat;
      _cachedLon = lon;
    }

    // fallback: forecastList가 없으면 빈 리스트
    forecastList ??= [];

    // Open-Meteo에서 내일 최고/최저 추출
    double? tomorrowMax;
    double? tomorrowMin;
    if (dailyJson != null) {
      final daily = dailyJson['daily'] as Map<String, dynamic>?;
      if (daily != null) {
        final idx = _findDateIndex(daily, 1);
        if (idx != null) {
          final maxList = (daily['temperature_2m_max'] as List?)?.cast<num>();
          final minList = (daily['temperature_2m_min'] as List?)?.cast<num>();
          tomorrowMax = maxList?[idx].toDouble();
          tomorrowMin = minList?[idx].toDouble();
        }
      }
    }

    // OWM에서 내일 날씨 상태·강수 확률 추출 (로컬 자정~자정 기준)
    final tomorrowStart = _localMidnight(1);
    final dayAfterStart = _localMidnight(2);
    final tomorrowItems = forecastList.where((item) {
      final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
      return !dt.isBefore(tomorrowStart) && dt.isBefore(dayAfterStart);
    }).toList();

    // Open-Meteo에서도 내일 강수 확률 추출
    int? openMeteoRainProb;
    if (dailyJson != null) {
      final daily = dailyJson['daily'] as Map<String, dynamic>?;
      if (daily != null) {
        final idx = _findDateIndex(daily, 1);
        if (idx != null) {
          final probList = (daily['precipitation_probability_max'] as List?)?.cast<num>();
          openMeteoRainProb = probList?[idx].toInt();
        }
      }
    }

    if (tomorrowMax != null && tomorrowMin != null) {
      // 날씨 상태는 OWM 낮 시간대 슬롯에서 가져옴
      Map<String, dynamic> repItem;
      if (tomorrowItems.isNotEmpty) {
        repItem = tomorrowItems.firstWhere(
          (item) {
            final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
            return dt.hour >= 12 && dt.hour < 15;
          },
          orElse: () => tomorrowItems.first,
        );
      } else if (forecastList.length > 8) {
        repItem = forecastList[8];
      } else if (forecastList.isNotEmpty) {
        repItem = forecastList.last;
      } else {
        // OWM 예보 없음 → Open-Meteo weathercode로 폴백
        final weatherCode = _openMeteoCodeToOwm(dailyJson);
        return DailyForecast(
          tempMax: tomorrowMax,
          tempMin: tomorrowMin,
          rainProbPercent: openMeteoRainProb ?? 0,
          weatherMain: weatherCode.$1,
          weatherCode: weatherCode.$2,
          date: _localMidnight(1),
        );
      }

      final weatherList = (repItem['weather'] as List?)?.cast<Map<String, dynamic>>();
      final weather = (weatherList != null && weatherList.isNotEmpty)
          ? weatherList.first
          : <String, dynamic>{'main': 'Clear', 'id': 800};
      final owmRainProb = tomorrowItems.isNotEmpty
          ? tomorrowItems
              .map((i) => (((i['pop'] as num?) ?? 0) * 100).round())
              .reduce((a, b) => a > b ? a : b)
          : 0;

      return DailyForecast(
        tempMax: tomorrowMax,
        tempMin: tomorrowMin,
        rainProbPercent: openMeteoRainProb ?? owmRainProb,
        weatherMain: weather['main'] as String? ?? 'Clear',
        weatherCode: weather['id'] as int? ?? 800,
        date: DateTime.fromMillisecondsSinceEpoch((repItem['dt'] as int) * 1000),
      );
    }

    // 폴백: OWM 집계
    if (tomorrowItems.isNotEmpty) {
      double overallMax = double.negativeInfinity;
      double overallMin = double.infinity;
      int maxRainProb = 0;
      for (final item in tomorrowItems) {
        final m = item['main'] as Map<String, dynamic>?;
        final slotTemp = (m?['temp'] as num?)?.toDouble() ?? 0.0;
        final pop = (((item['pop'] as num?) ?? 0) * 100).round();
        if (slotTemp > overallMax) overallMax = slotTemp;
        if (slotTemp < overallMin) overallMin = slotTemp;
        if (pop > maxRainProb) maxRainProb = pop;
      }
      final repItem = tomorrowItems.firstWhere(
        (item) {
          final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
          return dt.hour >= 12 && dt.hour < 15;
        },
        orElse: () => tomorrowItems.first,
      );
      final weatherList = (repItem['weather'] as List?)?.cast<Map<String, dynamic>>();
      final weather = (weatherList != null && weatherList.isNotEmpty)
          ? weatherList.first
          : <String, dynamic>{'main': 'Clear', 'id': 800};
      return DailyForecast(
        tempMax: overallMax == double.negativeInfinity ? 0.0 : overallMax,
        tempMin: overallMin == double.infinity ? 0.0 : overallMin,
        rainProbPercent: maxRainProb,
        weatherMain: weather['main'] as String? ?? 'Clear',
        weatherCode: weather['id'] as int? ?? 800,
        date: DateTime.fromMillisecondsSinceEpoch((repItem['dt'] as int) * 1000),
      );
    }

    if (forecastList.isNotEmpty) {
      final fallbackItem = forecastList.length > 8 ? forecastList[8] : forecastList.last;
      return DailyForecast.fromOwmForecastItem(fallbackItem);
    }

    // 모든 데이터 없음 → 기본값 반환
    return DailyForecast(
      tempMax: 0.0,
      tempMin: 0.0,
      rainProbPercent: 0,
      weatherMain: 'Clear',
      weatherCode: 800,
      date: _localMidnight(1),
    );
  }

  /// Open-Meteo weathercode → OWM weatherMain / weatherCode 변환 (폴백용)
  (String, int) _openMeteoCodeToOwm(Map<String, dynamic>? dailyJson) {
    if (dailyJson == null) return ('Clear', 800);
    final daily = dailyJson['daily'] as Map<String, dynamic>?;
    if (daily == null) return ('Clear', 800);
    final idx = _findDateIndex(daily, 1);
    if (idx == null) return ('Clear', 800);
    final codeList = (daily['weathercode'] as List?)?.cast<num>();
    final code = codeList?[idx].toInt() ?? 0;
    if (code == 0) return ('Clear', 800);
    if (code <= 3) return ('Clouds', 801);
    if (code <= 49) return ('Fog', 741);
    if (code <= 67) return ('Rain', 500);
    if (code <= 77) return ('Snow', 600);
    if (code <= 82) return ('Rain', 502);
    if (code <= 86) return ('Snow', 601);
    return ('Thunderstorm', 200);
  }

  // Duration.add 사용으로 월말 오버플로우 방지
  static DateTime _localMidnight(int daysFromToday) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.add(Duration(days: daysFromToday));
  }

  void invalidateCache() {
    _cachedWeather = null;
    _cachedForecast = null;
    _cachedDaily = null;
    _cacheTime = null;
    _cachedLat = null;
    _cachedLon = null;
  }
}
