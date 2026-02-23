import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/data/services/notification_service.dart';
import 'package:oneday/providers/settings_provider.dart';

/// 앱 첫 실행 및 설정 변경 시 알림 권한 요청 + 스케줄 등록
/// HomeScreen에서 watch → settings 변경 시 자동 재실행
final notificationSetupProvider = FutureProvider<void>((ref) async {
  final settings = ref.watch(notificationSettingsProvider);
  await NotificationService.requestPermission();
  await NotificationService.scheduleWithSettings(settings);
});
