import 'package:oneday/data/models/time_mode.dart';

extension DateTimeX on DateTime {
  TimeMode get timeMode {
    final h = hour;
    if (h >= 5 && h < 12) return TimeMode.morning;
    if (h >= 12 && h < 18) return TimeMode.lunch;
    return TimeMode.evening; // 18:00 ~ 04:59 (자정 이후 포함)
  }
}
