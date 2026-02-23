import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/core/theme/color_palette.dart';
import 'package:oneday/data/models/time_mode.dart';

abstract class AppTheme {
  static ThemeData forMode(TimeMode mode) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorSchemeForMode(mode),
      textTheme: GoogleFonts.notoSansTextTheme(
        ThemeData.dark().textTheme,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ColorScheme _colorSchemeForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return const ColorScheme.dark(
          primary: ColorPalette.morningPrimary,
          secondary: ColorPalette.morningSecondary,
          surface: Color(0xFF1A0A00),
        );
      case TimeMode.lunch:
        return const ColorScheme.dark(
          primary: ColorPalette.lunchPrimary,
          secondary: ColorPalette.lunchSecondary,
          surface: Color(0xFF00251A),
        );
      case TimeMode.evening:
        return const ColorScheme.dark(
          primary: ColorPalette.eveningPrimary,
          secondary: ColorPalette.eveningSecondary,
          surface: ColorPalette.eveningAccent,
        );
    }
  }

  /// 시간대별 Blur 강도
  static double blurSigmaForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return 4.0; // 낮은 blur - 선명한 정보
      case TimeMode.lunch:
        return 8.0; // 중간 blur
      case TimeMode.evening:
        return 14.0; // 높은 blur - 텍스트 집중
    }
  }

  /// 시간대별 배경 오버레이 불투명도
  static double overlayOpacityForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return 0.15;
      case TimeMode.lunch:
        return 0.20;
      case TimeMode.evening:
        return 0.35;
    }
  }

  /// 시간대별 폴백 배경색 (이미지 로드 전)
  static Color fallbackColorForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return const Color(0xFFFF8C42);
      case TimeMode.lunch:
        return const Color(0xFF4ECDC4);
      case TimeMode.evening:
        return const Color(0xFF2D1B69);
    }
  }
}
