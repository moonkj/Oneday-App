# CLAUDE.md - Oneday Flutter App

## 프로젝트 개요

**Oneday**는 하루의 시간 흐름에 따라 UI와 기능이 자동으로 변화하는 감성 루틴 Flutter 앱입니다.

슬로건: **"당신의 하루를, One Day가 디자인합니다."**

### 시간대별 모드
| 모드 | 시간 | 목적 |
|------|------|------|
| Morning | 05:00 ~ 11:59 | 날씨 정보 + 하루 시작 |
| Lunch | 12:00 ~ 17:59 | 리프레시 + 오후 환기 |
| Evening | 18:00 ~ 04:59 | 하루 기록 + 감성 마무리 |

---

## 기술 스택

- **Framework**: Flutter (최신 안정 버전)
- **State Management**: Riverpod 3.x (code-gen 스타일, `@riverpod` 어노테이션)
- **Local Storage**: Hive 2.x with hive_flutter
- **HTTP**: Dio 5.x
- **APIs**:
  - OpenWeatherMap One Call 3.0 (날씨)
  - Unsplash (배경 이미지)
- **UI**: google_fonts, lottie, cached_network_image, Glassmorphism (수동 구현)
- **이미지 저장**: screenshot + image_gallery_saver

---
### Testing Platform (필수)

**⚠️ 모든 테스트는 iOS 시뮬레이터에서 실행해야 합니다**

```bash
# iOS 디바이스 확인
flutter devices

# iOS 시뮬레이터에서 앱 실행
flutter run -d <iOS-DEVICE-ID>

# 예시
flutter run -d 5085C411-1720-42F8-8F9D-15CAFEA67CB6
```

### TDD Approach (Recommended)

1. **RED → GREEN → REFACTOR Cycle**
   - 🔴 **RED**: Write test first → Run test → Verify failure (iOS에서 실행)
   - 🟢 **GREEN**: Write minimal code to pass test (iOS에서 검증)
   - 🔵 **REFACTOR**: Improve code quality while keeping tests green (iOS에서 재검증)

2. **Coverage Target: 70%+**
   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   open coverage/html/index.html
   ```
---

## 아키텍처: Feature-First with Shared Core

```
lib/
├── core/
│   ├── config/         ← app_config.dart, hive_config.dart
│   ├── constants/      ← app_strings, lottie_assets, unsplash_queries
│   ├── extensions/     ← datetime_extensions (TimeMode 결정)
│   ├── theme/          ← app_theme, color_palette, text_styles
│   └── utils/
│       ├── greeting_picker.dart     ← 365개 인사말 일별 로테이션
│       ├── outfit_advisor.dart
│       └── quote_picker.dart
├── data/        ← 모델, 서비스(API 래퍼), 레포지토리(캐시+저장)
├── providers/
│   ├── settings_provider.dart       ← NotificationSettings (Hive 영속화)
│   ├── notification_provider.dart   ← 설정 변경 감지 → 자동 재스케줄
│   └── ...
└── features/
    ├── home/           ← 상단 앱바 (설정 아이콘 포함)
    ├── morning/
    ├── lunch/
    │   └── widgets/
    │       └── menu_recommendation_card.dart  ← 스와이프형 메뉴 추천
    ├── evening/
    └── settings/
        └── settings_screen.dart     ← 바텀시트 설정 화면
```

### 주요 에셋 구조
```
assets/
├── greetings/
│   ├── morning_greetings.json   ← 365개 아침 인사말
│   ├── lunch_greetings.json     ← 365개 점심 인사말
│   └── evening_greetings.json   ← 365개 저녁 인사말 (헤더용)
├── lottie/
└── quotes/
```

---

## 코드 생성 명령어

`@HiveType`, `@freezed`, `@riverpod` 어노테이션이 붙은 파일 수정 후 반드시 실행:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**절대 `.g.dart` 또는 `.freezed.dart` 파일을 직접 편집하지 마세요.**

---

## API 키 설정

키는 `lib/core/config/app_config.dart`에 placeholder 문자열로 작성됩니다.

**실제 키를 커밋하지 마세요.** 앱 실행 전 직접 입력:

```dart
static const String openWeatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
static const String unsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
```

### API 키 발급처
- **OpenWeatherMap**: https://openweathermap.org/api (One Call API 3.0 - 카드 등록 필요)
  - 대안: 2.5 endpoint (카드 불필요) → `Notes` 참고
- **Unsplash**: https://unsplash.com/developers (Demo: 50req/hour, Production: 5000req/hour)

---

## 핵심 규칙

1. **모든 한국어 UI 문자열**은 반드시 `lib/core/constants/app_strings.dart`에 작성
2. **Lottie 에셋 경로**는 `lib/core/constants/lottie_assets.dart`에 상수로 관리
3. **TimeMode 결정**은 `DateTimeX` extension (`lib/core/extensions/datetime_extensions.dart`)을 통해서만
4. **모든 프로바이더 파일**은 해당 파일에서 프로바이더를 export; 위젯 파일에 익명 프로바이더 금지
5. **`AsyncValue.when()`**의 error 상태는 항상 처리; `.value`를 직접 사용하지 말 것
6. **GlassCard**가 앱 전체에서 유일한 카드 컨테이너; 임시 컨테이너를 새로 만들지 말 것
7. **Freezed + Hive 혼용 금지**: `DailyRecord`는 plain class + TypeAdapter로만 구현
8. **새 에셋 추가 시** `pubspec.yaml`의 `flutter.assets` 목록에 반드시 선언 (누락 시 앱 흰 화면 발생)
9. **인사말**은 `GreetingPicker` 유틸리티를 통해서만 접근; `GreetingResolver`는 대체됨

---

## 앱 실행 방법

```bash
# 의존성 설치
flutter pub get

# 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
```

---

## 개발 팁: 시간대 디버깅

Debug 모드에서 HomeScreen 우상단에 모드 수동 전환 버튼 제공:
- 실제 시스템 시계를 기다리지 않고 3가지 모드 빠르게 테스트 가능

---

## 플랫폼별 설정

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>날씨 정보를 위해 현재 위치가 필요합니다</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>날씨 정보를 위해 현재 위치가 필요합니다</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>오늘의 기록 이미지를 갤러리에 저장합니다</string>
```

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<!-- Android 12 이하 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<!-- Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## 주요 주의사항

| 항목 | 내용 |
|------|------|
| Hive 초기화 | `Hive.openBox()`는 반드시 `runApp()` 전에 `main()`에서 실행. `settingsBox`도 포함 |
| Screenshot 해상도 | `devicePixelRatio` 곱하기로 고해상도 캡처 |
| Unsplash 캐시 | 같은 모드+날짜는 항상 캐시 반환 (rate limit 보호) |
| OWM 3.0 대안 | 401 오류 시 2.5 endpoint fallback: `api.openweathermap.org/data/2.5/weather` |
| Lottie 에셋 | `pubspec.yaml`의 `flutter.assets`에 반드시 선언 |
| image_gallery_saver iOS | 사진 권한 허용 후 첫 실행 시부터 정상 동작 |
| GreetingPicker 초기화 | `main()`에서 `GreetingPicker.initialize()` 호출 필수 (rootBundle 비동기 로드) |
| pubspec assets 누락 | JSON 파일 추가 후 `assets/greetings/` 등 경로 미선언 시 앱 흰 화면 |
| 알림 설정 영속화 | `NotificationSettingsNotifier`가 변경 즉시 Hive `settingsBox`에 저장 |
| 알림 재스케줄 | `notificationSetupProvider`가 `notificationSettingsProvider` watch → 설정 변경 시 자동 재등록 |

---

## Notes

### OWM API 2.5 Fallback Endpoints
```
현재 날씨: GET https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&lang=kr&appid={key}
5일 예보:  GET https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&units=metric&lang=kr&appid={key}
```

### Lottie 파일 소스
- https://lottiefiles.com (Free 라이선스 필터 적용)
- 검색어: `sunrise`, `stars`, `moon`, `clouds`, `sun`

### 한국어 명언 소스
- `assets/quotes/quotes_ko.json`에 30개 이상 수동 작성 권장

### 365개 인사말 시스템 (GreetingPicker)
- `assets/greetings/morning_greetings.json` / `lunch_greetings.json` / `evening_greetings.json`
- 날짜 기반 셔플: `Random(now.year)`로 연도 고정 시드 → 연내 모든 날짜에 다른 메시지
- 매일 자정 기준으로 인덱스 계산 (`dayOfYear % messages.length`)

### 점심 메뉴 추천 카드 (MenuRecommendationCard)
- 100개 한국 메뉴 풀에서 날짜 기반 셔플(`Random(now.year * 1000 + dayOfYear)`)로 매일 3개 선정
- 인트로 페이지(🍽️ + 좌우 화살표 애니메이션) + 메뉴 3개 PageView 구성
- PageView 내부 스와이프와 homeScreen 페이지 전환 구분: `NeverScrollableScrollPhysics` 아님, 물리 스와이프로 처리

### 설정 화면 (SettingsScreen)
- `showModalBottomSheet` + `BackdropFilter` blur로 글래스모피즘 바텀시트
- 알림 섹션: ☀️ 아침 / 🍽️ 점심 / 🌙 저녁 각각 ON/OFF + 시간 탭→TimePicker
- 법적 정보 섹션: 개인정보처리방침 / 이용약관 → `_LegalPage` StatelessWidget
- `showTimePicker()` + dark theme override로 어두운 TimePicker 스타일
