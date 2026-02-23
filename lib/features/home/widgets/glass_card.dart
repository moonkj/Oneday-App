import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oneday/core/theme/color_palette.dart';

/// Glassmorphism 공통 카드 컨테이너
/// 앱 전체에서 유일하게 사용하는 카드 스타일
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.blurSigma = 8.0,
    this.opacity = 0.12,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: ColorPalette.glassBorderColor.withOpacity(opacity),
              border: Border.all(
                color: ColorPalette.glassBorderColor,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
