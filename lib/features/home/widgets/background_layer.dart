import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/theme/app_theme.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/providers/background_image_provider.dart';

class BackgroundLayer extends ConsumerWidget {
  final TimeMode mode;

  const BackgroundLayer({required this.mode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(backgroundImageProvider(mode));
    final blurSigma = AppTheme.blurSigmaForMode(mode);
    final overlayOpacity = AppTheme.overlayOpacityForMode(mode);
    final fallbackColor = AppTheme.fallbackColorForMode(mode);

    return Stack(
      children: [
        // 배경 이미지
        Positioned.fill(
          child: imageAsync.when(
            data: (photo) => CachedNetworkImage(
              imageUrl: photo.regularUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: fallbackColor),
              errorWidget: (context, url, error) =>
                  Container(color: fallbackColor),
              fadeInDuration: const Duration(milliseconds: 800),
            ),
            loading: () => AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: fallbackColor,
            ),
            error: (_, __) => Container(color: fallbackColor),
          ),
        ),

        // 어두운 오버레이
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            color: Colors.black.withValues(alpha: overlayOpacity),
          ),
        ),

        // Blur 필터
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
