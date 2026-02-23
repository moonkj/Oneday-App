import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:oneday/core/config/hive_config.dart';

class NotificationSettings {
  final bool morningEnabled;
  final int morningHour;
  final int morningMinute;
  final bool lunchEnabled;
  final int lunchHour;
  final int lunchMinute;
  final bool eveningEnabled;
  final int eveningHour;
  final int eveningMinute;

  const NotificationSettings({
    this.morningEnabled = true,
    this.morningHour = 7,
    this.morningMinute = 0,
    this.lunchEnabled = false,
    this.lunchHour = 12,
    this.lunchMinute = 0,
    this.eveningEnabled = true,
    this.eveningHour = 21,
    this.eveningMinute = 0,
  });

  NotificationSettings copyWith({
    bool? morningEnabled,
    int? morningHour,
    int? morningMinute,
    bool? lunchEnabled,
    int? lunchHour,
    int? lunchMinute,
    bool? eveningEnabled,
    int? eveningHour,
    int? eveningMinute,
  }) {
    return NotificationSettings(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      lunchEnabled: lunchEnabled ?? this.lunchEnabled,
      lunchHour: lunchHour ?? this.lunchHour,
      lunchMinute: lunchMinute ?? this.lunchMinute,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(_loadFromHive());

  static NotificationSettings _loadFromHive() {
    final box = Hive.box<dynamic>(HiveConfig.settingsBox);
    return NotificationSettings(
      morningEnabled: box.get(HiveConfig.keyMorningEnabled, defaultValue: true) as bool,
      morningHour: box.get(HiveConfig.keyMorningHour, defaultValue: 7) as int,
      morningMinute: box.get(HiveConfig.keyMorningMinute, defaultValue: 0) as int,
      lunchEnabled: box.get(HiveConfig.keyLunchEnabled, defaultValue: false) as bool,
      lunchHour: box.get(HiveConfig.keyLunchHour, defaultValue: 12) as int,
      lunchMinute: box.get(HiveConfig.keyLunchMinute, defaultValue: 0) as int,
      eveningEnabled: box.get(HiveConfig.keyEveningEnabled, defaultValue: true) as bool,
      eveningHour: box.get(HiveConfig.keyEveningHour, defaultValue: 21) as int,
      eveningMinute: box.get(HiveConfig.keyEveningMinute, defaultValue: 0) as int,
    );
  }

  void _save(NotificationSettings s) {
    final box = Hive.box<dynamic>(HiveConfig.settingsBox);
    box.put(HiveConfig.keyMorningEnabled, s.morningEnabled);
    box.put(HiveConfig.keyMorningHour, s.morningHour);
    box.put(HiveConfig.keyMorningMinute, s.morningMinute);
    box.put(HiveConfig.keyLunchEnabled, s.lunchEnabled);
    box.put(HiveConfig.keyLunchHour, s.lunchHour);
    box.put(HiveConfig.keyLunchMinute, s.lunchMinute);
    box.put(HiveConfig.keyEveningEnabled, s.eveningEnabled);
    box.put(HiveConfig.keyEveningHour, s.eveningHour);
    box.put(HiveConfig.keyEveningMinute, s.eveningMinute);
  }

  void setMorningEnabled(bool v) { state = state.copyWith(morningEnabled: v); _save(state); }
  void setMorningTime(int h, int m) { state = state.copyWith(morningHour: h, morningMinute: m); _save(state); }
  void setLunchEnabled(bool v) { state = state.copyWith(lunchEnabled: v); _save(state); }
  void setLunchTime(int h, int m) { state = state.copyWith(lunchHour: h, lunchMinute: m); _save(state); }
  void setEveningEnabled(bool v) { state = state.copyWith(eveningEnabled: v); _save(state); }
  void setEveningTime(int h, int m) { state = state.copyWith(eveningHour: h, eveningMinute: m); _save(state); }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);
