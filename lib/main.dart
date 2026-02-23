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

  // 명언 + 저녁 메시지 + 인사말 초기화
  await QuotePicker.initialize();
  await EveningMessagePicker.initialize();
  await GreetingPicker.initialize();

  // 홈 화면 위젯에 오늘의 명언 저장
  final todayQuote = QuotePicker.todayQuote();
  await HomeWidget.setAppGroupId('group.com.imurmkj.oneday');
  await HomeWidget.saveWidgetData<String>('quote_text', todayQuote.text);
  await HomeWidget.saveWidgetData<String>('quote_author', todayQuote.author);
  await HomeWidget.updateWidget(
    iOSName: 'OnedayWidget',
    androidName: 'OnedayWidgetProvider',
  );

  // AdMob 초기화
  await MobileAds.instance.initialize();

  // 알림 플러그인 초기화 (권한 요청 + 스케줄은 notificationSetupProvider가 처리)
  await NotificationService.initialize();

  runApp(
    const ProviderScope(
      child: OnedayApp(),
    ),
  );
}
