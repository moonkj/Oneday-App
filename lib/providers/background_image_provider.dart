import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/data/models/unsplash_photo.dart';
import 'package:oneday/data/repositories/image_repository.dart';
import 'package:oneday/data/services/unsplash_service.dart';
import 'package:oneday/providers/weather_provider.dart';

final unsplashServiceProvider = Provider<UnsplashService>((ref) {
  return UnsplashService(ref.watch(dioProvider));
});

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  return ImageRepository(ref.watch(unsplashServiceProvider));
});

class BackgroundImageNotifier
    extends FamilyAsyncNotifier<UnsplashPhoto, TimeMode> {
  @override
  Future<UnsplashPhoto> build(TimeMode arg) async {
    final repo = ref.watch(imageRepositoryProvider);

    // API 키가 없으면 폴백 즉시 반환
    if (AppConfig.unsplashAccessKey == 'YOUR_UNSPLASH_ACCESS_KEY') {
      return UnsplashPhoto.fallback(arg.name);
    }

    return repo.fetchForMode(arg);
  }

  Future<void> refresh() async {
    final repo = ref.read(imageRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.refreshForMode(arg));
  }
}

final backgroundImageProvider = AsyncNotifierProviderFamily<
    BackgroundImageNotifier, UnsplashPhoto, TimeMode>(
  BackgroundImageNotifier.new,
);
