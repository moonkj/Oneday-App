import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/utils/image_renderer.dart';
import 'package:oneday/providers/background_image_provider.dart';
import 'package:oneday/providers/daily_record_provider.dart';

class ShareImageCache {
  final Uint8List shareBytes;   // 1080×1350 공유용
  final Uint8List galleryBytes; // 2160×2700 갤러리 저장용

  const ShareImageCache({
    required this.shareBytes,
    required this.galleryBytes,
  });
}

/// 문장·배경이 바뀔 때 자동으로 두 해상도를 백그라운드 렌더링.
/// Evening 뷰에서 watch하면 문장 저장 즉시 렌더링 시작.
final shareImageCacheProvider =
    FutureProvider<ShareImageCache?>((ref) async {
  final sentence = ref.watch(dailyRecordProvider).sentence;
  final imageAsync = ref.watch(backgroundImageProvider);

  if (sentence.trim().isEmpty) return null;

  final bgUrl = imageAsync.valueOrNull?.fullUrl;

  // 두 해상도 병렬 렌더링 (백그라운드)
  final results = await Future.wait([
    renderShareImage(sentence, bgUrl),
    renderGalleryImage(sentence, bgUrl),
  ]);

  return ShareImageCache(
    shareBytes: results[0],
    galleryBytes: results[1],
  );
});
