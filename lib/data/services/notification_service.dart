import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:oneday/providers/settings_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _morningId = 1;
  static const int _lunchId = 3;
  static const int _eveningId = 2;

  static const _androidChannel = AndroidNotificationDetails(
    'oneday_channel',
    'Oneday 알림',
    channelDescription: '아침/저녁 루틴 알림',
    importance: Importance.high,
    priority: Priority.high,
  );

  static const _iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidChannel,
    iOS: _iosDetails,
  );

  /// 앱 시작 시 한 번만 호출
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // 기기의 실제 로컬 시간대 설정 (없으면 Asia/Seoul 기본값)
    try {
      final String localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  /// iOS / Android 13+ 알림 권한 요청
  static Future<bool> requestPermission() async {
    // iOS
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final result = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }

    // Android 13+ (API 33+)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final result = await android?.requestNotificationsPermission();
    return result ?? false;
  }

  /// 설정값에 따라 알림 스케줄 (기존 취소 후 재등록)
  static Future<void> scheduleWithSettings(NotificationSettings settings) async {
    await cancelMorning();
    await cancelLunch();
    await cancelEvening();

    if (settings.morningEnabled) {
      await _scheduleMorning(settings.morningHour, settings.morningMinute);
    }
    if (settings.lunchEnabled) {
      await _scheduleLunch(settings.lunchHour, settings.lunchMinute);
    }
    if (settings.eveningEnabled) {
      await _scheduleEvening(settings.eveningHour, settings.eveningMinute);
    }
  }

  static Future<void> _scheduleMorning(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _morningId,
      '좋은 아침이에요! ☀️',
      '오늘의 날씨와 코디 추천을 확인해보세요',
      scheduled,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _scheduleLunch(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _lunchId,
      '점심 시간이에요! 🍽️',
      '오늘 메뉴 후보를 확인하고 맛있는 한 끼 드세요',
      scheduled,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _scheduleEvening(int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _eveningId,
      '오늘 하루는 어땠나요? 🌙',
      '오늘의 한 문장을 기록하고 내일을 위한 날씨 예보를 확인해보세요',
      scheduled,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelMorning() async {
    await _plugin.cancel(_morningId);
  }

  static Future<void> cancelLunch() async {
    await _plugin.cancel(_lunchId);
  }

  static Future<void> cancelEvening() async {
    await _plugin.cancel(_eveningId);
  }

  /// 모든 알림 취소
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
