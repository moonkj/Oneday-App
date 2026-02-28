import 'package:dio/dio.dart';
import 'package:oneday/core/config/app_config.dart';

class WeatherService {
  final Dio _dio;

  WeatherService(this._dio);

  /// 백엔드 서버를 통해 현재 날씨 조회
  Future<Map<String, dynamic>> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await _dio.get(
      '${AppConfig.backendBaseUrl}/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// 백엔드 서버를 통해 5일 예보 조회
  Future<Map<String, dynamic>> fetchForecast({
    required double lat,
    required double lon,
  }) async {
    final response = await _dio.get(
      '${AppConfig.backendBaseUrl}/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Open-Meteo 기반 일별 최고/최저 온도 (정확한 00:00~23:59 기준)
  Future<Map<String, dynamic>> fetchDailyForecast({
    required double lat,
    required double lon,
  }) async {
    final response = await _dio.get(
      '${AppConfig.backendBaseUrl}/daily',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// 기상청 초단기실황 + 초단기예보 기반 현재 날씨 (한국 실측 데이터)
  Future<Map<String, dynamic>> fetchKmaWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await _dio.get(
      '${AppConfig.backendBaseUrl}/kma_current',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
