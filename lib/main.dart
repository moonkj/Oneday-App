import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:oneday/app.dart';
import 'package:oneday/core/config/hive_config.dart';
import 'package:oneday/core/utils/evening_message_picker.dart';
import 'package:oneday/core/utils/greeting_picker.dart';
import 'package:oneday/core/utils/quote_picker.dart';
import 'package:oneday/data/models/daily_record.dart';
import 'package:oneday/data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바 스타일: 배경 투명 + 아이콘 흰색
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Hive 초기화 (runApp 전에 반드시 실행)
  await Hive.initFlutter();
  Hive.registerAdapter(DailyRecordAdapter());
  await Hive.openBox<DailyRecord>(HiveConfig.dailyRecordsBox);
  await Hive.openBox<dynamic>(HiveConfig.settingsBox);

  // 명언 + 저녁 메시지 + 인사말 초기화 (병렬)
  await Future.wait([
    QuotePicker.initialize(),
    EveningMessagePicker.initialize(),
    GreetingPicker.initialize(),
  ]);

  // 앱 최대한 빨리 렌더링 시작 (나머지 초기화는 백그라운드에서 진행)
  _postRunInit();
  runApp(
    const ProviderScope(
      child: OnedayApp(),
    ),
  );
}

/// runApp() 이후 비동기로 처리해도 되는 초기화 작업들
Future<void> _postRunInit() async {
  // 홈 화면 위젯에 오늘의 명언 저장
  final todayQuote = QuotePicker.todayQuote();
  await HomeWidget.setAppGroupId('group.com.imurmkj.oneday');
  await Future.wait([
    HomeWidget.saveWidgetData<String>('quote_text', todayQuote.text),
    HomeWidget.saveWidgetData<String>('quote_author', todayQuote.author),
  ]);
  await HomeWidget.updateWidget(
    iOSName: 'OnedayWidget',
    androidName: 'OnedayWidgetProvider',
  );

  // ATT 권한 요청 (iOS 14+ 광고 추적 동의)
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // AdMob + 알림 초기화 병렬
  await Future.wait([
    MobileAds.instance.initialize(),
    NotificationService.initialize(),
  ]);
}
