import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/data/models/weather_data.dart';
import 'package:oneday/data/repositories/weather_repository.dart';
import 'package:oneday/data/services/location_service.dart';
import 'package:oneday/data/services/weather_service.dart';

// --- 인프라 프로바이더 ---

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  return dio;
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(ref.watch(dioProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(ref.watch(weatherServiceProvider));
});

// --- 위치 프로바이더 ---

final locationProvider = FutureProvider<({double lat, double lon})>((ref) async {
  final service = ref.watch(locationServiceProvider);
  final position = await service.getCurrentPosition();
  return (lat: position.latitude, lon: position.longitude);
});

// --- 날씨 프로바이더 ---

class WeatherNotifier extends AsyncNotifier<WeatherData> {
  @override
  Future<WeatherData> build() async {
    final location = await ref.watch(locationProvider.future);
    final repo = ref.watch(weatherRepositoryProvider);
    return repo.fetchCurrentWeather(lat: location.lat, lon: location.lon);
  }

  Future<void> refresh() async {
    final repo = ref.read(weatherRepositoryProvider);
    repo.invalidateCache();
    ref.invalidate(locationProvider); // 위치 오류 시 재시도할 수 있도록
    ref.invalidateSelf();
    ref.invalidate(tomorrowForecastProvider);
  }
}

final weatherNotifierProvider =
    AsyncNotifierProvider<WeatherNotifier, WeatherData>(WeatherNotifier.new);

// --- 내일 예보 프로바이더 ---

final tomorrowForecastProvider =
    FutureProvider<DailyForecast>((ref) async {
  final location = await ref.watch(locationProvider.future);
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.fetchTomorrowForecast(lat: location.lat, lon: location.lon);
});

// 도시 이름 (WeatherData.cityName 에서 파생)
final cityNameProvider = Provider<String>((ref) {
  return ref.watch(weatherNotifierProvider).valueOrNull?.cityName ?? '';
});
