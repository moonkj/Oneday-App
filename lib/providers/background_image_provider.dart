import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/data/models/unsplash_photo.dart';
import 'package:oneday/data/repositories/image_repository.dart';
import 'package:oneday/data/services/unsplash_service.dart';
import 'package:oneday/providers/time_provider.dart';
import 'package:oneday/providers/weather_provider.dart';

final unsplashServiceProvider = Provider<UnsplashService>((ref) {
  return UnsplashService(ref.watch(dioProvider));
});

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  return ImageRepository(ref.watch(unsplashServiceProvider));
});

class BackgroundImageNotifier extends AsyncNotifier<UnsplashPhoto> {
  @override
  Future<UnsplashPhoto> build() async {
    final mode = ref.watch(effectiveTimeModeProvider);
    final repo = ref.watch(imageRepositoryProvider);

    // API 키가 없으면 폴백 즉시 반환
    if (AppConfig.unsplashAccessKey == 'YOUR_UNSPLASH_ACCESS_KEY') {
      return UnsplashPhoto.fallback(_queryForMode(mode));
    }

    return repo.fetchForMode(mode);
  }

  Future<void> refresh() async {
    final mode = ref.read(effectiveTimeModeProvider);
    final repo = ref.read(imageRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.refreshForMode(mode));
  }

  String _queryForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return 'sunrise morning';
      case TimeMode.lunch:
        return 'blue sky daytime';
      case TimeMode.evening:
        return 'night sky stars';
    }
  }
}

final backgroundImageProvider =
    AsyncNotifierProvider<BackgroundImageNotifier, UnsplashPhoto>(
  BackgroundImageNotifier.new,
);
