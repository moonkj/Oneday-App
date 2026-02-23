import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:oneday/core/config/hive_config.dart';
import 'package:oneday/providers/settings_provider.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_settings_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveConfig.settingsBox);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('NotificationSettingsNotifier - 초기 상태 (Hive에서 로드)', () {
    test('Hive 값 없을 때 기본값 로드', () {
      final notifier = NotificationSettingsNotifier();
      expect(notifier.state.morningEnabled, isTrue);
      expect(notifier.state.morningHour, 7);
      expect(notifier.state.lunchEnabled, isFalse);
      expect(notifier.state.eveningEnabled, isTrue);
      expect(notifier.state.eveningHour, 21);
    });
  });

  group('NotificationSettingsNotifier - setMorningEnabled()', () {
    test('아침 알림 끄기 → state 변경 + Hive 저장', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setMorningEnabled(false);

      expect(notifier.state.morningEnabled, isFalse);
      // Hive에 저장됐는지 확인 (새 notifier로 재로드)
      final notifier2 = NotificationSettingsNotifier();
      expect(notifier2.state.morningEnabled, isFalse);
    });
  });

  group('NotificationSettingsNotifier - setMorningTime()', () {
    test('아침 알림 시간 변경 → 영속화', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setMorningTime(8, 30);

      expect(notifier.state.morningHour, 8);
      expect(notifier.state.morningMinute, 30);

      final notifier2 = NotificationSettingsNotifier();
      expect(notifier2.state.morningHour, 8);
      expect(notifier2.state.morningMinute, 30);
    });
  });

  group('NotificationSettingsNotifier - setLunchEnabled()', () {
    test('점심 알림 켜기', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setLunchEnabled(true);

      expect(notifier.state.lunchEnabled, isTrue);
      final notifier2 = NotificationSettingsNotifier();
      expect(notifier2.state.lunchEnabled, isTrue);
    });
  });

  group('NotificationSettingsNotifier - setLunchTime()', () {
    test('점심 알림 시간 변경', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setLunchTime(11, 45);

      expect(notifier.state.lunchHour, 11);
      expect(notifier.state.lunchMinute, 45);
    });
  });

  group('NotificationSettingsNotifier - setEveningEnabled()', () {
    test('저녁 알림 끄기', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setEveningEnabled(false);

      expect(notifier.state.eveningEnabled, isFalse);
      final notifier2 = NotificationSettingsNotifier();
      expect(notifier2.state.eveningEnabled, isFalse);
    });
  });

  group('NotificationSettingsNotifier - setEveningTime()', () {
    test('저녁 알림 시간 변경', () {
      final notifier = NotificationSettingsNotifier();
      notifier.setEveningTime(22, 0);

      expect(notifier.state.eveningHour, 22);
      expect(notifier.state.eveningMinute, 0);
    });
  });

  group('notificationSettingsProvider - ProviderContainer', () {
    test('ProviderContainer로 notificationSettingsProvider 읽기 (lines 92-94)', () {
      // notificationSettingsProvider 선언 라인 커버 (ref) => NotificationSettingsNotifier()
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final settings = container.read(notificationSettingsProvider);
      expect(settings, isA<NotificationSettings>());
      expect(settings.morningEnabled, isTrue); // 기본값 확인
    });
  });
}
