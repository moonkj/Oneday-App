import 'package:oneday/core/config/app_secrets.dart';

abstract class AppConfig {
  // --- 백엔드 서버 URL ---
  // 로컬 테스트: 'http://localhost:8000'
  // Railway 배포: https://railway.com/project/86262044-33bb-4126-9a51-3452b5fb9b15
  static const String backendBaseUrl = 'https://grateful-flow-production-6c7b.up.railway.app';

  // --- Unsplash ---
  // 실제 키는 lib/core/config/app_secrets.dart (gitignored) 에 보관
  // app_secrets.dart.example 참고
  static const String unsplashAccessKey = AppSecrets.unsplashAccessKey;
  static const String unsplashBaseUrl = 'https://api.unsplash.com';

  // 캐시 설정
  static const Duration weatherCacheDuration = Duration(minutes: 30);

  // --- AdMob ---
  // App ID는 ios/Runner/Info.plist의 GADApplicationIdentifier 에도 동일하게 입력되어 있습니다.

  /// 네이티브 광고 Unit ID (iOS)
  static const String nativeAdUnitIdIos = 'ca-app-pub-9059891578497774/6896483045';

  /// 네이티브 광고 Unit ID (Android)
  static const String nativeAdUnitIdAndroid = 'ca-app-pub-3940256099942544/2247696110';
}
