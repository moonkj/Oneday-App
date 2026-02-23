import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oneday/core/theme/color_palette.dart';
import 'package:oneday/data/models/time_mode.dart';

abstract class AppTextStyles {
  static TextStyle headline(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
      case TimeMode.lunch:
        return GoogleFonts.notoSans(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: ColorPalette.textOnDark,
          height: 1.4,
        );
      case TimeMode.evening:
        return GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ColorPalette.textOnDark,
          height: 1.5,
        );
    }
  }

  static TextStyle subheadline(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
      case TimeMode.lunch:
        return GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ColorPalette.textSubtle,
          height: 1.5,
        );
      case TimeMode.evening:
        return GoogleFonts.notoSerif(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: ColorPalette.textSubtle,
          height: 1.6,
        );
    }
  }

  static TextStyle body(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
      case TimeMode.lunch:
        return GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColorPalette.textOnDark,
          height: 1.6,
        );
      case TimeMode.evening:
        return GoogleFonts.notoSerif(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColorPalette.textOnDark,
          height: 1.7,
        );
    }
  }

  static TextStyle temperature(TimeMode mode) {
    return GoogleFonts.notoSans(
      fontSize: 48,
      fontWeight: FontWeight.w200,
      color: ColorPalette.textOnDark,
      height: 1.1,
    );
  }

  static TextStyle label(TimeMode mode) {
    return GoogleFonts.notoSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: ColorPalette.textSubtle,
      letterSpacing: 0.5,
    );
  }

  static TextStyle input(TimeMode mode) {
    return GoogleFonts.notoSerif(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: ColorPalette.textOnDark,
      height: 1.7,
    );
  }

  static TextStyle quote(TimeMode mode) {
    return GoogleFonts.notoSerif(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorPalette.textOnDark,
      height: 1.8,
      fontStyle: FontStyle.italic,
    );
  }
}
