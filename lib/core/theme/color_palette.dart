import 'package:flutter/material.dart';

/// 시간대별 컬러 토큰
abstract class ColorPalette {
  // --- Morning (05:00 ~ 11:59) ---
  static const morningPrimary = Color(0xFFFF8C42); // 따뜻한 오렌지
  static const morningSecondary = Color(0xFFFFD166); // 밝은 골드
  static const morningAccent = Color(0xFFF4F1DE); // 크림 화이트
  static const morningGlass = Color(0xFFFFFFFF); // 글래스 베이스

  // --- Lunch (12:00 ~ 17:59) ---
  static const lunchPrimary = Color(0xFF4ECDC4); // 민트 그린
  static const lunchSecondary = Color(0xFF44BBA4); // 에메랄드
  static const lunchAccent = Color(0xFF87CEEB); // 스카이 블루
  static const lunchGlass = Color(0xFFFFFFFF);

  // --- Evening (18:00 ~ 04:59) ---
  static const eveningPrimary = Color(0xFF6C63FF); // 딥 퍼플
  static const eveningSecondary = Color(0xFFFFD700); // 골드
  static const eveningAccent = Color(0xFF2D1B69); // 딥 인디고
  static const eveningGlass = Color(0xFFFFFFFF);

  // --- Shared ---
  static const textOnDark = Color(0xFFFFFFFF);
  static const textSubtle = Color(0xCCFFFFFF); // 80% 흰색
  static const glassBorderColor = Color(0x33FFFFFF); // 20% 흰색 테두리
}
