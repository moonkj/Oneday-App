/// OWM API 응답에서 필요한 날씨 데이터만 추출한 모델
class WeatherData {
  final double tempCurrent;
  final double feelsLike;
  final double tempMax;
  final double tempMin;
  final int rainProbPercent;
  final double uvIndex;
  final String weatherMain;
  final String weatherDescription;
  final int weatherCode;
  final DateTime fetchedAt;
  final String cityName;

  const WeatherData({
    required this.tempCurrent,
    required this.feelsLike,
    required this.tempMax,
    required this.tempMin,
    required this.rainProbPercent,
    required this.uvIndex,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherCode,
    required this.fetchedAt,
    this.cityName = '',
  });

  /// OWM 2.5 current weather API 응답에서 파싱
  factory WeatherData.fromOwm({
    required Map<String, dynamic> currentJson,
    required Map<String, dynamic>? forecastJson, // 예보 첫 번째 항목 (강수 확률용)
    double? todayTempMax, // 오늘 전체 예보 집계 최고 온도
    double? todayTempMin, // 오늘 전체 예보 집계 최저 온도
    double? currentTempOverride, // 기상청/Open-Meteo 현재 기온 (정확도 우선)
    double? feelsLikeOverride, // Open-Meteo 체감 기온
    double? uvIndexOverride, // Open-Meteo UV 최고치
    int? weatherCodeOverride, // 기상청 날씨 코드 (OWM 형식으로 변환된 값)
  }) {
    // weather 배열이 비어있을 경우 기본값으로 폴백
    final weatherList = (currentJson['weather'] as List?)?.cast<Map<String, dynamic>>();
    final weather = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList.first
        : <String, dynamic>{'main': 'Clear', 'description': '', 'id': 800};

    // main 구조에서 데이터 추출 (2.5 API 포맷)
    final main = currentJson['main'] as Map<String, dynamic>?;
    final currentTemp = currentTempOverride ?? (main?['temp'] as num?)?.toDouble() ?? 0.0;

    final effectiveCode = weatherCodeOverride ?? weather['id'] as int? ?? 800;

    return WeatherData(
      tempCurrent: currentTemp,
      feelsLike: feelsLikeOverride ?? (main?['feels_like'] as num?)?.toDouble() ?? 0.0,
      // 오늘 전체 예보 집계값 우선, 없으면 현재 날씨 max/min 사용
      tempMax: todayTempMax ?? (main?['temp_max'] as num?)?.toDouble() ?? currentTemp,
      tempMin: todayTempMin ?? (main?['temp_min'] as num?)?.toDouble() ?? currentTemp,
      rainProbPercent: forecastJson != null
          ? (((forecastJson['pop'] as num?) ?? 0) * 100).round()
          : 0,
      uvIndex: uvIndexOverride ?? 0.0,
      weatherMain: weatherCodeOverride != null
          ? _owmCodeToMain(weatherCodeOverride)
          : weather['main'] as String? ?? 'Clear',
      weatherDescription: weather['description'] as String? ?? '',
      weatherCode: effectiveCode,
      fetchedAt: DateTime.now(),
      cityName: currentJson['name'] as String? ?? '',
    );
  }

  static String _owmCodeToMain(int code) {
    if (code >= 200 && code < 300) return 'Thunderstorm';
    if (code >= 300 && code < 400) return 'Drizzle';
    if (code >= 500 && code < 600) return 'Rain';
    if (code >= 600 && code < 700) return 'Snow';
    if (code >= 700 && code < 800) return 'Atmosphere';
    if (code == 800) return 'Clear';
    return 'Clouds';
  }

  WeatherData copyWith({
    double? uvIndex,
    int? rainProbPercent,
  }) {
    return WeatherData(
      tempCurrent: tempCurrent,
      feelsLike: feelsLike,
      tempMax: tempMax,
      tempMin: tempMin,
      rainProbPercent: rainProbPercent ?? this.rainProbPercent,
      uvIndex: uvIndex ?? this.uvIndex,
      weatherMain: weatherMain,
      weatherDescription: weatherDescription,
      weatherCode: weatherCode,
      fetchedAt: fetchedAt,
      cityName: cityName,
    );
  }
}

/// 내일 날씨 예보 모델
class DailyForecast {
  final double tempMax;
  final double tempMin;
  final int rainProbPercent;
  final String weatherMain;
  final int weatherCode;
  final DateTime date;

  const DailyForecast({
    required this.tempMax,
    required this.tempMin,
    required this.rainProbPercent,
    required this.weatherMain,
    required this.weatherCode,
    required this.date,
  });

  /// OWM 2.5 forecast API 응답에서 내일 데이터 파싱
  factory DailyForecast.fromOwmForecastItem(Map<String, dynamic> json) {
    // weather 배열이 비어있을 경우 기본값으로 폴백
    final weatherList = (json['weather'] as List?)?.cast<Map<String, dynamic>>();
    final weather = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList.first
        : <String, dynamic>{'main': 'Clear', 'id': 800};

    final main = json['main'] as Map<String, dynamic>?;
    final temp = (main?['temp'] as num?)?.toDouble() ?? 0.0;

    return DailyForecast(
      tempMax: (main?['temp_max'] as num?)?.toDouble() ?? temp,
      tempMin: (main?['temp_min'] as num?)?.toDouble() ?? temp,
      rainProbPercent: (((json['pop'] as num?) ?? 0) * 100).round(),
      weatherMain: weather['main'] as String? ?? 'Clear',
      weatherCode: weather['id'] as int? ?? 800,
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }
}
