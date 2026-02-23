import 'package:oneday/core/constants/app_strings.dart';

/// 시간 + 날씨 기반 한국어 인사말 생성 (순수 함수)
abstract class GreetingResolver {
  static String morningGreeting({
    required int hour,
    required String weatherMain,
  }) {
    // 날씨 우선 처리
    final w = weatherMain.toLowerCase();
    if (w == 'rain' || w == 'drizzle') return AppStrings.morningGreetingRainy;
    if (w == 'snow') return AppStrings.morningGreetingSnowy;
    if (w == 'clouds') return AppStrings.morningGreetingCloudy;

    // 시간대별 처리
    if (hour < 7) return AppStrings.morningGreetingEarly;
    if (hour < 10) return AppStrings.morningGreetingMid;
    return AppStrings.morningGreetingLate;
  }

  static String lunchGreeting({required int hour}) {
    if (hour < 14) return AppStrings.lunchGreeting;
    return AppStrings.lunchAfternoonGreeting;
  }

  static String eveningGreeting({required int hour}) {
    if (hour >= 23 || hour < 3) return AppStrings.eveningGreetingMidnight;
    return AppStrings.eveningGreeting;
  }

  static String lunchReminder() {
    final index = DateTime.now().minute % AppStrings.lunchReminderMessages.length;
    return AppStrings.lunchReminderMessages[index];
  }
}
