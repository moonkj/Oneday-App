import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/providers/settings_provider.dart';

void main() {
  group('NotificationSettings - 기본값', () {
    test('morning: enabled=true, 07:00', () {
      const s = NotificationSettings();
      expect(s.morningEnabled, isTrue);
      expect(s.morningHour, 7);
      expect(s.morningMinute, 0);
    });

    test('lunch: enabled=false, 12:00', () {
      const s = NotificationSettings();
      expect(s.lunchEnabled, isFalse);
      expect(s.lunchHour, 12);
      expect(s.lunchMinute, 0);
    });

    test('evening: enabled=true, 21:00', () {
      const s = NotificationSettings();
      expect(s.eveningEnabled, isTrue);
      expect(s.eveningHour, 21);
      expect(s.eveningMinute, 0);
    });
  });

  group('NotificationSettings.copyWith', () {
    test('일부 필드만 변경 시 나머지 유지', () {
      const original = NotificationSettings();
      final updated = original.copyWith(morningEnabled: false, morningHour: 9);

      expect(updated.morningEnabled, isFalse);
      expect(updated.morningHour, 9);
      // 나머지 유지
      expect(updated.morningMinute, 0);
      expect(updated.lunchEnabled, isFalse);
      expect(updated.eveningEnabled, isTrue);
    });

    test('저녁 시간 변경', () {
      const original = NotificationSettings();
      final updated = original.copyWith(eveningHour: 22, eveningMinute: 30);

      expect(updated.eveningHour, 22);
      expect(updated.eveningMinute, 30);
      expect(updated.morningEnabled, isTrue); // 나머지 유지
    });

    test('점심 활성화 변경', () {
      const original = NotificationSettings();
      final updated = original.copyWith(lunchEnabled: true, lunchHour: 11, lunchMinute: 30);

      expect(updated.lunchEnabled, isTrue);
      expect(updated.lunchHour, 11);
      expect(updated.lunchMinute, 30);
    });
  });
}
