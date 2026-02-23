import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/extensions/datetime_extensions.dart';
import 'package:oneday/data/models/time_mode.dart';

void main() {
  group('DateTimeX.timeMode', () {
    test('05:00 → morning', () {
      expect(DateTime(2026, 2, 22, 5, 0).timeMode, TimeMode.morning);
    });

    test('11:59 → morning (경계)', () {
      expect(DateTime(2026, 2, 22, 11, 59).timeMode, TimeMode.morning);
    });

    test('12:00 → lunch (경계)', () {
      expect(DateTime(2026, 2, 22, 12, 0).timeMode, TimeMode.lunch);
    });

    test('17:59 → lunch (경계)', () {
      expect(DateTime(2026, 2, 22, 17, 59).timeMode, TimeMode.lunch);
    });

    test('18:00 → evening (경계)', () {
      expect(DateTime(2026, 2, 22, 18, 0).timeMode, TimeMode.evening);
    });

    test('04:59 → evening (자정 이후)', () {
      expect(DateTime(2026, 2, 22, 4, 59).timeMode, TimeMode.evening);
    });
  });
}
