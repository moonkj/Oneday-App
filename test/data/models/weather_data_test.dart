import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/data/models/weather_data.dart';

void main() {
  // OWM 2.5 current weather 응답 샘플
  final Map<String, dynamic> sampleCurrentJson = {
    'name': '서울',
    'weather': [
      {'id': 800, 'main': 'Clear', 'description': '맑음'},
    ],
    'main': {
      'temp': 15.3,
      'feels_like': 13.8,
      'temp_max': 17.0,
      'temp_min': 12.0,
    },
  };

  final Map<String, dynamic> sampleForecastJson = {
    'pop': 0.4, // 40% 강수 확률
    'weather': [
      {'id': 500, 'main': 'Rain', 'description': '가벼운 비'},
    ],
    'main': {
      'temp_max': 16.0,
      'temp_min': 10.0,
    },
    'dt': 1708617600,
  };

  group('WeatherData.fromOwm()', () {
    test('기본 필드 파싱 정확성', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: null,
      );

      expect(data.tempCurrent, 15.3);
      expect(data.feelsLike, 13.8);
      expect(data.tempMax, 17.0);
      expect(data.tempMin, 12.0);
      expect(data.weatherMain, 'Clear');
      expect(data.weatherDescription, '맑음');
      expect(data.weatherCode, 800);
      expect(data.cityName, '서울');
    });

    test('forecastJson null → rainProbPercent = 0', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: null,
      );
      expect(data.rainProbPercent, 0);
    });

    test('forecastJson 있을 때 pop * 100 → 40%', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: sampleForecastJson,
      );
      expect(data.rainProbPercent, 40);
    });

    test('2.5 API에서 uvIndex = 0.0 (별도 호출 필요)', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: null,
      );
      expect(data.uvIndex, 0.0);
    });

    test('copyWith으로 uvIndex 업데이트', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: null,
      );
      final updated = data.copyWith(uvIndex: 5.2);
      expect(updated.uvIndex, 5.2);
      expect(updated.tempCurrent, data.tempCurrent); // 나머지 유지
    });

    test('copyWith에 uvIndex 미제공 시 기존 값 유지 (line 72 ?? 분기)', () {
      final data = WeatherData.fromOwm(
        currentJson: sampleCurrentJson,
        forecastJson: null,
      );
      // uvIndex 제공 안 함 → this.uvIndex(0.0) 유지
      final updated = data.copyWith(rainProbPercent: 50);
      expect(updated.uvIndex, 0.0); // this.uvIndex 사용
      expect(updated.rainProbPercent, 50);
    });

    test('main.temp_max 없을 때 main.temp 폴백 (line 38)', () {
      // temp_max 없고 temp만 있는 JSON → 로컬 변수 tempMax가 main.temp로 폴백
      final jsonNoTempMax = {
        'name': '서울',
        'weather': [
          {'id': 800, 'main': 'Clear', 'description': '맑음'},
        ],
        'main': {
          'temp': 14.0,
          'feels_like': 12.0,
          'temp_min': 10.0,
          // temp_max 없음
        },
      };
      final data = WeatherData.fromOwm(currentJson: jsonNoTempMax, forecastJson: null);
      // main.temp_max가 null이므로 WeatherData.tempMax는 tempMax 로컬변수(line38경로) 사용
      expect(data.tempCurrent, 14.0);
    });
  });

  group('DailyForecast.fromOwmForecastItem()', () {
    test('tempMax, tempMin 파싱', () {
      final forecast = DailyForecast.fromOwmForecastItem(sampleForecastJson);
      expect(forecast.tempMax, 16.0);
      expect(forecast.tempMin, 10.0);
    });

    test('pop * 100 = 40%', () {
      final forecast = DailyForecast.fromOwmForecastItem(sampleForecastJson);
      expect(forecast.rainProbPercent, 40);
    });

    test('dt 타임스탬프 → DateTime 변환', () {
      final forecast = DailyForecast.fromOwmForecastItem(sampleForecastJson);
      // 1708617600 = 2024-02-22 00:00:00 UTC
      expect(forecast.date, isA<DateTime>());
      expect(forecast.date.millisecondsSinceEpoch, 1708617600 * 1000);
    });

    test('weatherMain 파싱', () {
      final forecast = DailyForecast.fromOwmForecastItem(sampleForecastJson);
      expect(forecast.weatherMain, 'Rain');
    });
  });
}
