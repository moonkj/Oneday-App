import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/data/models/weather_data.dart';
import 'package:oneday/data/services/weather_service.dart';

class WeatherRepository {
  final WeatherService _service;

  WeatherData? _cachedWeather;
  List<Map<String, dynamic>>? _cachedForecast;
  Map<String, dynamic>? _cachedDaily; // Open-Meteo 일별 데이터
  DateTime? _cacheTime;
  double? _cachedLat;
  double? _cachedLon;

  WeatherRepository(this._service);

  bool _isCacheValidFor(double lat, double lon) {
    if (_cachedWeather == null || _cacheTime == null) return false;
    if (DateTime.now().difference(_cacheTime!) >= AppConfig.weatherCacheDuration) return false;
    if (_cachedLat == null || _cachedLon == null) return false;
    final moved = (lat - _cachedLat!).abs() >= 0.1 || (lon - _cachedLon!).abs() >= 0.1;
    return !moved;
  }

  /// Open-Meteo 응답에서 오늘/내일 인덱스 찾기
  int? _findDateIndex(Map<String, dynamic> daily, int daysFromToday) {
    final times = (daily['time'] as List?)?.cast<String>();
    if (times == null) return null;
    final now = DateTime.now();
    final target = DateTime(now.year, now.month, now.day + daysFromToday);
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
      forecastList = (forecastJson['list'] as List).cast<Map<String, dynamic>>();
      _cachedForecast = forecastList;
    } catch (e) {
      // forecast fetch failed, proceed without forecast data
    }

    // Open-Meteo 일별 최고/최저 (정확한 00:00~23:59 기준)
    double? todayTempMax;
    double? todayTempMin;
    try {
      final dailyJson = await _service.fetchDailyForecast(lat: lat, lon: lon);
      _cachedDaily = dailyJson;
      final daily = dailyJson['daily'] as Map<String, dynamic>?;
      if (daily != null) {
        final idx = _findDateIndex(daily, 0);
        if (idx != null) {
          final maxList = (daily['temperature_2m_max'] as List?)?.cast<num>();
          final minList = (daily['temperature_2m_min'] as List?)?.cast<num>();
          todayTempMax = maxList?[idx].toDouble();
          todayTempMin = minList?[idx].toDouble();
        }
      }
    } catch (e) {
      // Open-Meteo daily fetch failed, proceed without daily data
    }

    _cachedWeather = WeatherData.fromOwm(
      currentJson: currentJson,
      forecastJson: forecastList?.isNotEmpty == true ? forecastList!.first : null,
      todayTempMax: todayTempMax,
      todayTempMin: todayTempMin,
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
    // Open-Meteo 캐시 사용 (없으면 새로 요청)
    Map<String, dynamic>? dailyJson = _cachedDaily;
    if (dailyJson == null) {
      try {
        dailyJson = await _service.fetchDailyForecast(lat: lat, lon: lon);
        _cachedDaily = dailyJson;
      } catch (e) {
        // Open-Meteo daily fetch failed, proceed without daily data
      }
    }

    // OWM 예보 (날씨 상태·강수 확률용)
    List<Map<String, dynamic>> forecastList;
    if (_cachedForecast != null) {
      forecastList = _cachedForecast!;
    } else {
      final forecastJson = await _service.fetchForecast(lat: lat, lon: lon);
      forecastList = (forecastJson['list'] as List).cast<Map<String, dynamic>>();
      _cachedForecast = forecastList;
    }

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

    // OWM에서 내일 날씨 상태·강수 확률 추출 (자정~자정 로컬 기준)
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
      final repItem = tomorrowItems.isNotEmpty
          ? tomorrowItems.firstWhere(
              (item) {
                final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
                return dt.hour >= 12 && dt.hour < 15;
              },
              orElse: () => tomorrowItems.first,
            )
          : (forecastList.length > 8 ? forecastList[8] : forecastList.last);

      final weather = (repItem['weather'] as List).first as Map<String, dynamic>;
      final owmRainProb = tomorrowItems.isNotEmpty
          ? tomorrowItems
              .map((i) => (((i['pop'] as num?) ?? 0) * 100).round())
              .reduce((a, b) => a > b ? a : b)
          : 0;

      return DailyForecast(
        tempMax: tomorrowMax,
        tempMin: tomorrowMin,
        rainProbPercent: openMeteoRainProb ?? owmRainProb,
        weatherMain: weather['main'] as String,
        weatherCode: weather['id'] as int,
        date: DateTime.fromMillisecondsSinceEpoch((repItem['dt'] as int) * 1000),
      );
    }

    // 폴백: OWM 집계
    if (tomorrowItems.isNotEmpty) {
      double overallMax = double.negativeInfinity;
      double overallMin = double.infinity;
      int maxRainProb = 0;
      for (final item in tomorrowItems) {
        final m = item['main'] as Map<String, dynamic>;
        final slotTemp = (m['temp'] as num).toDouble();
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
      final weather = (repItem['weather'] as List).first as Map<String, dynamic>;
      return DailyForecast(
        tempMax: overallMax,
        tempMin: overallMin,
        rainProbPercent: maxRainProb,
        weatherMain: weather['main'] as String,
        weatherCode: weather['id'] as int,
        date: DateTime.fromMillisecondsSinceEpoch((repItem['dt'] as int) * 1000),
      );
    }

    final fallbackItem = forecastList.length > 8 ? forecastList[8] : forecastList.last;
    return DailyForecast.fromOwmForecastItem(fallbackItem);
  }

  static DateTime _localMidnight(int daysFromToday) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + daysFromToday);
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
