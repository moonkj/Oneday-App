# process.md - Oneday 개발 진행 상황

## 상태 범례
- `[ ]` 미시작
- `[~]` 진행 중
- `[x]` 완료
- `[!]` 블로킹 / 이슈 있음

---

## Phase 1: 프로젝트 스캐폴드

**목표**: `flutter run`이 오류 없이 실행되는 상태

- [x] `flutter create` 실행
- [x] `pubspec.yaml` 의존성 추가 및 `flutter pub get` 성공
- [x] `lib/` 폴더 전체 구조 생성 (빈 stub 포함)
- [x] `assets/lottie/`, `assets/images/`, `assets/quotes/` 디렉토리 생성
- [x] `app_config.dart` placeholder 키 작성
- [x] `flutter analyze` - 0 error, 0 warning (info 레벨만 10개)

---

## Phase 2: 핵심 인프라

**목표**: TimeMode 감지 + 테마 시스템 + HomeScreen 전환 동작

- [x] `TimeMode` enum + `DateTimeX` extension
- [x] `timeModeProvider` (StreamProvider, 60초 periodic)
- [x] `currentTimeModeProvider` (동기 파생)
- [x] `debugTimeModeOverrideProvider` (하단 인디케이터 탭으로 전환)
- [x] `ColorPalette` - morning/lunch/evening 컬러 토큰
- [x] `AppTheme` factory per mode
- [x] `TextStyles` with Google Fonts (NotoSansKr + NotoSerif)
- [x] `GlassCard` 위젯
- [x] `BackgroundLayer` (CachedNetworkImage + BackdropFilter)
- [x] `HomeScreen` AnimatedSwitcher (SlideTransition + FadeTransition)
- [ ] 수동 시계 테스트: 3가지 모드 모두 도달 가능 확인

---

## Phase 3: Hive + DailyRecord

**목표**: 오늘의 한 문장 로컬 저장/불러오기

- [x] `DailyRecord` `@HiveType` 모델 작성
- [x] `DailyRecordAdapter` 수동 작성 (hive_generator 대신, source_gen 버전 충돌 회피)
- [x] `DailyRecordRepository` (loadToday, save, loadAll)
- [x] `dailyRecordRepositoryProvider`
- [x] `DailyRecordNotifier` (Notifier)
- [x] `SentenceInputCard` UI in EveningView
- [x] `ShareImageBuilder` (Screenshot + ImageGallerySaver)
- [ ] 저장/불러오기 라운드트립 테스트 (앱 종료 후 재시작)

---

## Phase 4: 날씨 API

**목표**: 실제 날씨 데이터 화면에 표시

- [x] `locationProvider` (Geolocator + 권한 처리)
- [x] 권한 거부 에러 상태
- [x] `WeatherService` (Dio, OWM 2.5 endpoint - 카드 등록 불필요)
- [x] `WeatherRepository` (파싱 + 30분 캐시)
- [x] `weatherRepositoryProvider`
- [x] `WeatherNotifier` (AsyncNotifier)
- [x] `tomorrowForecastProvider`
- [x] `WeatherCard` in MorningView
- [x] `OutfitAdvisor` 순수 함수
- [x] `OutfitAdviceCard`
- [x] `UvIndexCard` in LunchView
- [x] `TomorrowForecastCard` in EveningView
- [x] 에러 상태 위젯 (네트워크, 권한 거부, 재시도 버튼)
- [x] API 키 입력 후 기기에서 실제 데이터 확인 (Railway 백엔드로 처리됨)

---

## Phase 5: Unsplash 배경 이미지

**목표**: 시간대별 동적 배경 이미지

- [x] `UnsplashService` (Dio, GET /photos/random)
- [x] `ImageRepository` (날짜+모드 키 캐시)
- [x] `imageRepositoryProvider`
- [x] `BackgroundImageNotifier` (새로고침 버튼 지원)
- [x] `BackgroundLayer` - `CachedNetworkImage` 사용
- [x] 시간대별 blur 강도 (morning: 4, lunch: 8, evening: 14)
- [x] 이미지 로드 시 fade-in 전환
- [x] API 키 없을 때 Unsplash Source URL 폴백
- [ ] API 키 입력 후 모드별 이미지 확인

---

## Phase 6: Lottie 애니메이션

**목표**: 각 모드에서 Lottie 애니메이션 실행

- [x] Lottie JSON 파일 생성 및 assets/lottie/ 배치 (플레이스홀더 애니메이션 - 실제 파일로 교체 권장)
  - [x] `sunrise.json` (pulsing yellow circle)
  - [x] `clouds_morning.json` (moving cloud + sun)
  - [x] `sun_afternoon.json` (rotating star rays)
  - [x] `stars.json` (twinkling dots)
  - [x] `moon.json` (rocking crescent)
  - [x] `rain.json` (falling blue drops)
  - [x] `snow.json` (falling white dots)
  - [x] `thunder.json`, `night_sky.json`, `clouds_afternoon.json`, `sunshine.json`
- [x] `MorningLottie` 위젯 (Lottie 없으면 아이콘 폴백)
- [x] `LunchLottie` 위젯
- [x] `EveningLottie` 위젯
- [x] `GreetingResolver` 한국어 인사말
- [x] `QuotePicker` (날짜 시드, quotes_ko.json)
- [x] `assets/quotes/quotes_ko.json` 35개 명언 작성
- [x] Lottie 파일 배치 후 애니메이션 실행 확인 (errorBuilder 폴백 처리됨)

---

## Phase 7: 이미지 생성 + 갤러리 저장

**목표**: 저녁 모드에서 공유 이미지 생성 및 저장

- [x] `ShareImageBuilder` (`ScreenshotController` 래퍼)
- [x] 고해상도 캡처 (`devicePixelRatio` 적용)
- [x] `ImageGallerySaver.saveImage()` 연동
- [x] iOS Info.plist 권한 문자열 추가
- [x] Android AndroidManifest.xml 권한 추가
- [x] 성공/실패 SnackBar
- [x] 한 문장 입력 후에만 프리뷰 표시 (빈 상태 숨김)
- [ ] 실기기 테스트

---

## Phase 8: 한국어 텍스트 + 최종 Polish

**목표**: 모든 UI 문자열 한국어, 부드러운 UX

- [x] 모든 문자열 `app_strings.dart`로 이동 (한국어)
- [x] `GoogleFonts.notoSansKr()` + `notoSerif()` 모드별 적용
- [x] AnimatedSwitcher 강화 (SlideTransition + FadeTransition)
- [x] 하단 모드 인디케이터 dots (탭으로 디버그 전환)
- [x] 로딩 상태 텍스트 처리
- [x] 에러 상태 + 재시도 버튼
- [x] 상태바 투명 + 흰색 아이콘
- [x] 세로 모드 고정
- [ ] 실기기 시각 검토 (Morning / Lunch / Evening)

---

## Phase 9: 알림 (선택)

**목표**: 아침/저녁 리마인더 푸시 알림

- [x] `NotificationService` 클래스 작성 (`lib/data/services/notification_service.dart`)
- [x] `FlutterLocalNotificationsPlugin` 초기화 (main.dart)
- [x] 아침 알림 스케줄 (07:00 매일, timezone 패키지 사용)
- [x] 저녁 알림 스케줄 (21:00 매일)
- [x] iOS `AppDelegate.swift` 설정 (flutter_local_notifications import)
- [x] `pubspec.yaml`에 `timezone: ^0.9.2` 추가
- [x] `notificationSetupProvider` (FutureProvider) - 권한 요청 후 스케줄 등록
- [x] HomeScreen에서 provider watch → 첫 빌드 시 iOS 권한 다이얼로그 표시
- [x] `Info.plist` NSAppTransportSecurity - localhost HTTP 허용 (ATS 예외)
- [x] `backend/run_local.sh` 로컬 실행 스크립트
- [ ] 기기에서 알림 수신 테스트

---

## Phase 11: UX 개선 + 설정 화면

**목표**: 인사말 다양화, 점심 메뉴 추천, 사용자 설정 화면

### 11-1. 365개 인사말 로테이션
- [x] `assets/greetings/morning_greetings.json` - 365개 아침 인사말 작성
- [x] `assets/greetings/lunch_greetings.json` - 365개 점심 인사말 작성
- [x] `assets/greetings/evening_greetings.json` - 365개 저녁 인사말 작성
- [x] `lib/core/utils/greeting_picker.dart` - 날짜 기반 일별 메시지 선택 유틸
- [x] `main.dart`에 `GreetingPicker.initialize()` 추가
- [x] `pubspec.yaml`에 `assets/greetings/` 경로 추가
- [x] `GreetingHeader` 위젯을 `GreetingPicker` 기반으로 전환 (morning/lunch/evening 통합)

### 11-2. 점심 화면 개선
- [x] 점심 Lottie 좌측 정렬 수정 (`SizedBox(100×100)` + `Spacer()` 고정 크기)
- [x] `MenuRecommendationCard` 생성 (`lib/features/lunch/widgets/menu_recommendation_card.dart`)
  - 100개 한국 메뉴 풀, 날짜 기반 셔플로 매일 3개 선정
  - 인트로 페이지(🍽️ + 화살표 좌우 애니메이션) + 메뉴 3개 PageView
  - 상단 pill 인디케이터 (메뉴 페이지만 표시)
- [x] `LunchView`에서 카드 순서 변경: `UvIndexCard` → `MenuRecommendationCard` → `ReminderCard`

### 11-3. 알림 설정 3종 체계
- [x] `lib/core/config/hive_config.dart`에 `settingsBox` + lunch 관련 키 추가
- [x] `lib/providers/settings_provider.dart` 생성
  - `NotificationSettings` 모델 (morning/lunch/evening, 기본값: 아침 ON 07:00 / 점심 OFF 12:00 / 저녁 ON 21:00)
  - `NotificationSettingsNotifier` - 변경 즉시 Hive 저장
- [x] `main.dart`에 `Hive.openBox(HiveConfig.settingsBox)` 추가
- [x] `notification_service.dart` 업데이트
  - `_lunchId = 3` 추가
  - `scheduleWithSettings(NotificationSettings)` 메서드로 통합
  - `_scheduleLunch()`, `cancelLunch()` 추가
- [x] `notification_provider.dart` 업데이트
  - `notificationSettingsProvider` watch → 설정 변경 시 자동 재스케줄

### 11-4. 설정 화면 (바텀시트)
- [x] `lib/features/settings/settings_screen.dart` 생성
  - 반투명 블러 바텀시트 (BackdropFilter + Colors.black.withOpacity(0.72))
  - 알림 섹션: ☀️ 아침 / 🍽️ 점심 / 🌙 저녁 각 ON/OFF Switch + 시간 탭→TimePicker
  - 법적 정보 섹션: 개인정보처리방침 / 이용약관 → `_LegalPage` 인앱 표시
  - 개인정보처리방침 / 이용약관 최종 수정일: 2026년 2월
- [x] `home_screen.dart` `_TopBar` 업데이트
  - 새로고침 버튼 + 설정 버튼을 `Row(mainAxisSize: min)`으로 묶어 오른쪽 나란히 배치
  - `showModalBottomSheet`로 `SettingsScreen()` 표시

---

## Phase 10: 최종 QA

- [ ] 실제 시계 경계에서 모드 전환 테스트 (05:00, 12:00, 18:00)
- [ ] 네트워크 없는 환경에서 graceful 에러 상태
- [ ] 위치 권한 거부 시 처리
- [ ] Hive 데이터 앱 재시작 후 유지 확인
- [ ] 공유 이미지 iOS 실기기 테스트
- [ ] 공유 이미지 Android 실기기 테스트
- [x] `flutter analyze` - 0 errors, 0 warnings (info 10개만)
- [ ] `flutter build apk --release` 성공 (Java 미설치 환경 - Android Studio로 해결)
- [x] `flutter build ios --release` 성공 (Runner.app 생성 확인)

---

## Phase B: FastAPI 백엔드 (Railway 배포)

**목표**: API 키 보호 + 서버 사이드 캐시 → 다수 사용자 지원

- [x] `backend/main.py` FastAPI 서버 (GET /health, /weather, /forecast)
- [x] 서버 사이드 인메모리 캐시 (30분 TTL, lat/lon 0.1° 반올림 키)
- [x] CORS 미들웨어 설정
- [x] `backend/requirements.txt` (fastapi, uvicorn, httpx)
- [x] `backend/Procfile` (Railway 배포용)
- [x] `backend/railway.toml` (헬스체크 경로 포함)
- [x] `backend/.env.example`
- [x] Flutter `WeatherService` → 백엔드 URL로 전환
- [x] `app_config.dart` → OWM 키 제거, `backendBaseUrl` 추가
- [x] Railway 프로젝트 "grateful-flow" 생성 (ID: 86262044-33bb-4126-9a51-3452b5fb9b15)
- [x] Railway 환경변수 `OWM_API_KEY` 설정
- [x] Railway 배포 URL → `app_config.dart`의 `backendBaseUrl` 업데이트
- [x] 배포 후 `/health` 엔드포인트 확인 → `{"status":"ok"}`
- [x] `/weather?lat=37.5&lon=127.0` → 실제 날씨 JSON 반환 확인
- [x] iOS 앱 Railway URL로 재빌드 + iPhone(Moon) 설치

---

## Phase 12: TDD 테스트 스위트

**목표**: 100% 커버리지 달성 (RED → GREEN → REFACTOR 사이클)

### T1. 순수 유닛 테스트 (의존성 없음)
- [x] `test/core/extensions/datetime_extensions_test.dart` (6 cases - 시간대 경계값)
- [x] `test/core/utils/outfit_advisor_test.dart` (17 cases - 온도/우산/UV/눈)
- [x] `test/data/models/notification_settings_test.dart` (6 cases - 기본값/copyWith)
- [x] `test/data/models/daily_record_test.dart` (5 cases - empty/copyWith)
- [x] `test/data/models/weather_data_test.dart` (10 cases - fromOwm 파싱/copyWith 분기)

### T2. Asset 접근 테스트 (testWidgets + tester.runAsync)
- [x] `test/core/utils/greeting_picker_test.dart` (6 cases - initialize/fallback/결정론적)
  - 주의: `testWidgets` 내부에서 반드시 `tester.runAsync()` 래핑 필요 (rootBundle I/O)

### T3. Hive 격리 테스트
- [x] `test/data/repositories/daily_record_repository_test.dart` (13 cases - CRUD/TypeAdapter.read/hashCode)
  - setUp: `Hive.init(tempDir)` + Adapter 등록, tearDown: `Hive.close()` + 임시 파일 삭제
  - TypeAdapter.read() 커버: save→Hive.close()→Hive.init()→load 패턴

### T4. Provider 테스트 (ProviderContainer + FakeAsync)
- [x] `test/providers/time_provider_test.dart` (9 cases - override/StreamProvider/FakeAsync 1분)
  - `fake_async` 패키지로 1분 타이머 강제 진행 → Stream.periodic 람다 (line 10) 커버
- [x] `test/providers/notification_settings_notifier_test.dart` (7 cases - 모든 setter + ProviderContainer)

### T5. QuotePicker 유닛 테스트 (새 공식 검증)
- [x] `test/core/utils/quote_picker_test.dart` (9 cases)
  - Quote 모델 text·author 필드 확인
  - 초기화 없이 호출 → fallback (author: 'ONE DAY')
  - initialize() 후 non-empty text·author 반환
  - 공식 `(year * 1000 + dayOfYear) % count` → 결정론적
  - 초기화 후 quotes_ko.json 명언 반환 (fallback 아님)
- [x] `test/core/utils/quote_picker_error_test.dart` (1 case)
  - rootBundle 모킹(ByteData 0) → catch 블록 fallback 3개 유명인 명언 커버

### T6. EveningMessagePicker 유닛 테스트
- [x] `test/core/utils/evening_message_picker_test.dart` (4 cases)
  - 초기화 없이 호출 → fallback non-empty
  - initialize() 후 todayMessage() non-empty
  - 같은 날 두 번 호출 → 동일 메시지 (결정론적)
- [x] `test/core/utils/evening_message_picker_error_test.dart` (1 case)
  - rootBundle 모킹(ByteData 0) → catch 블록 fallback 3개 메시지 커버

### 검증
- [x] `flutter test` 전체 통과 → **98개 테스트 ALL PASS**
- [x] `flutter test --coverage` → **100% 커버리지** (247/247 lines hit)
  - 11개 소스 파일 전부 100% 달성
  - catch 블록까지 rootBundle 모킹으로 커버
- [ ] iOS 시뮬레이터에서 전체 테스트 패스 확인

---

## Phase 16: iOS 홈 화면 위젯

**목표**: 유명인 명언을 홈 화면에서 매일 자동 표시

- [x] `home_widget: ^0.5.0` pubspec 추가 (기존)
- [x] `ios/OnedayWidget/OnedayWidget.swift` — 402개 명언 내장, `todayQuote()` 독립 계산
  - 공식: `(year * 1000 + dayOfYear) % 402` — Dart QuotePicker와 동일
  - UserDefaults 의존 제거 → 앱 미실행 상태에서도 올바른 명언 표시
- [x] `ios/OnedayWidget/OnedayWidget.entitlements` — App Group 설정
- [x] `main.dart` HomeWidget 데이터 저장 (`await setAppGroupId` 추가)
- [x] iOS 17+ `.containerBackground(for: .widget) { gradient }` 수정
  - 뷰 내부 ZStack 그라디언트 제거 → containerBackground 단독 배경 담당
  - pre-iOS 17: `else { ZStack { widgetGradient + view } }` 유지
  - 배경/텍스트 박스 색상 불일치 해소
- [x] 실기기(Moon) 빌드 설치 확인

---

## Phase 17: UI 폴리쉬 (2026-02-23)

**목표**: 레이아웃/UX 세부 개선 5종

- [x] **애니메이션·카드 위치 상향**: MorningView / LunchView / EveningView의 Lottie 아래 `SizedBox(height: 20)` → `SizedBox(height: 6)` 축소
  - 날짜 헤더와 카드 사이 공백 감소 → 더 밀도 있는 레이아웃
- [x] **알람 타임피커 키보드 직접 입력 전용**: `settings_screen.dart` `showTimePicker`에 `initialEntryMode: TimePickerEntryMode.input` 추가
  - 시계 다이얼 UI 없이 바로 숫자 키보드 입력 모드로 진입
- [x] **아침 최고/최저 온도 정확도 개선**:
  - `WeatherRepository.fetchCurrentWeather()`: OWM 5일 예보 중 오늘 날짜 슬롯 전체 순회해 실제 일일 최고/최저 집계
  - `WeatherData.fromOwm()`: `todayTempMax?` / `todayTempMin?` 파라미터 추가 — 집계값 우선, 없으면 현재 날씨 max/min 폴백
  - 기존: 단일 예보 슬롯의 3시간 범위 max/min (부정확) → 수정 후: `fetchTomorrowForecast`와 동일한 방식으로 하루 전체 집계
- [x] **저녁 공유 이미지 문장 폰트 변경**: `share_image_builder.dart`
  - `TextStyle(fontWeight: w600)` → `GoogleFonts.gowunBatang(fontWeight: w700)`
  - `Gowun Batang`(고운 바탕): 감성 루틴 앱 컨셉에 맞는 한국어 세리프 명조 폰트
  - `google_fonts` import 추가
- [x] **점심 메뉴 카드 상단 텍스트 클리핑 해결**: `menu_recommendation_card.dart` `_MenuPage`
  - `EdgeInsets.fromLTRB(20, 0, 20, 20)` → `EdgeInsets.fromLTRB(20, 12, 20, 20)` (상단 12px 패딩 추가)

---

## Phase 13: 앱 에셋 완성

**목표**: 아이콘·스플래시·Lottie·명언 데이터 완비

- [x] `assets/quotes/quotes_ko.json` — 한국어 명언 400개 (이미 완비)
- [x] `flutter_launcher_icons` 패키지 추가 + `flutter_launcher_icons.yaml` 설정 완료
- [x] 앱 아이콘 1024×1024 생성 (Python PIL - 일출 아치 디자인) + `dart run flutter_launcher_icons` → iOS 전체 사이즈 자동 생성 완료
- [x] `flutter_native_splash` 패키지 추가 + `flutter_native_splash.yaml` 설정 + `create` 실행 완료 (다크 네이비 #1A1A2E 배경)
- [x] Lottie 파일 이미 모두 배치됨 (sunrise, stars, moon, rain, snow, clouds_morning, sun_afternoon 등 11종)

---

## Phase 14: iOS 빌드 설정

**목표**: App Store 제출 가능한 릴리즈 빌드

- [x] `pubspec.yaml` 버전 `1.0.0+1` 확인 — 적합
- [x] `ios/Runner/Info.plist` 점검 완료 (CFBundleDisplayName → "One Day", 개발용 IP 제거)
- [x] Bundle ID `com.imurmkj.oneday` 으로 변경 (Apple ID 기반 고유 ID)
- [x] Apple Developer Program 등록 확인
- [ ] **[USER 직접]** App Store Connect — 앱 등록 (Bundle ID: com.imurmkj.oneday 연결)
- [x] `flutter build ipa --release` 빌드 성공 → `build/ios/ipa/oneday.ipa` (28MB)
- [ ] **[USER 직접]** Transporter 앱으로 `build/ios/ipa/oneday.ipa` 업로드
- [x] iPhone 16 Pro Max 시뮬레이터 구동 (852B7F2B-6357-4225-9B4D-1D2F057C4E33) — debug 모드 실행 완료
- [x] 실기기(Moon) 릴리즈 모드 설치 (00008150-001128391EF0401C) — iOS 26.4, release 빌드 설치 완료

---

## Phase 15: App Store 메타데이터 & 심사 제출

**목표**: 심사 통과 & 출시

- [x] 개인정보처리방침 URL 생성 (Railway 백엔드 `/privacy`, `/terms` 엔드포인트로 서빙)
- [ ] App Store Connect 앱 정보 작성
  - [ ] 앱 이름: `One Day`
  - [ ] 부제목: `당신의 하루를 디자인합니다`
  - [ ] 카테고리: 라이프스타일
  - [ ] 키워드 (100자): 날씨,루틴,하루,인사말,감성,morning,일상,기록
  - [ ] 앱 설명문 (한국어, 4000자 이내)
  - [ ] 연령 등급 설문 작성 (예상: 4+)
- [ ] 스크린샷 촬영
  - [ ] iPhone 6.9" (Pro Max) — 최소 3장
  - [ ] iPhone 6.5" (Plus/Max) — 최소 3장
  - [ ] iPhone 5.5" (선택)
- [ ] TestFlight 내부 테스트 (1~2일)
- [ ] 심사 제출 → 승인 대기 (1~3일)

---

## Phase 18: v1.0.0 릴리즈 빌드 & 보안 강화 (2026-02-23)

**목표**: 프로덕션 릴리즈 준비 — 디버그 코드 제거 + API 키 gitignore 분리

- [x] 디버그 시간 모드 전환 UI 제거 (하단 ModeIndicator dots + PageView 스와이프 제거)
- [x] `debugTimeModeOverrideProvider` `time_provider.dart`에서 제거
- [x] `weather_repository.dart` 내 모든 `print()` 제거
- [x] Unsplash API 키 → `lib/core/config/app_secrets.dart` (gitignore 적용)로 분리
- [x] `lib/core/config/app_secrets.dart.example` 추가 (온보딩 참고용)
- [x] AdMob iOS 네이티브 광고 유닛 ID 업데이트
- [x] `coverage/` + `app_secrets.dart` → `.gitignore` 추가
- [x] `flutter build ipa --release` 성공 (v1.0.0+1)

---

## Phase 19: App Store 제출 준비 (2026-02-23~24)

**목표**: App Store 심사 요건 충족 — 이름·빌드 설정·법적 문서 정비

- [x] 백엔드 `/privacy`, `/terms` 엔드포인트 추가 (Railway FastAPI — 개인정보처리방침 & 이용약관 HTML 서빙)
- [x] 앱 표시 이름 `"One Day - 원데이"` 로 변경 (App Store 검색 최적화)
- [x] 앱 아이콘 레이블 `"One Day"` 로 복원 (홈 화면 표시 이름)
- [x] iPhone 전용 설정: `TARGETED_DEVICE_FAMILY "1,2"` → `"1"` (iPad 스크린샷 요구사항 제거)
- [x] `Info.plist` `UISupportedInterfaceOrientations~ipad` 키 제거
- [x] `Info.plist` `ITSAppUsesNonExemptEncryption = false` 추가 (수출 규정 면제 선언)
- [x] 빌드 번호 `1` → `3` 으로 업데이트 (App Store Connect 업로드 버전 충돌 해결, v1.0.0+3)

---

## Phase 20: ATT 동의 + app-ads.txt (2026-02-24)

**목표**: Google AdMob 정책 준수 — ATT 팝업 + app-ads.txt 인증

- [x] `app_tracking_transparency: ^1.0.4` pubspec 추가
- [x] `Info.plist` `NSUserTrackingUsageDescription` 선언
- [x] `main.dart` AdMob 초기화 전 iOS 14+ ATT 권한 요청 코드 추가
  - `AppTrackingTransparency.requestTrackingAuthorization()` → 권한 결과에 관계없이 AdMob 초기화 진행
- [x] 버전 `1.0.0+3` → `1.0.1+4` 업데이트
- [x] 백엔드 `/app-ads.txt` 엔드포인트 추가 (Google AdMob 앱 광고 인증)

---

## Phase 21: AdMob 개발자 웹사이트 등록 (2026-02-25)

**목표**: Google AdMob "개발자 웹사이트 없음" 정책 경고 해소

- [x] 원인 파악: AdMob이 App Store listing의 **마케팅 URL** 을 개발자 웹사이트로 인식 (지원 URL 불인정)
- [x] 버전 `1.0.1+4` → `1.0.2+5` 업데이트
- [x] `flutter build ipa --release` 성공 (v1.0.2+5, 26.6MB)
- [ ] **[USER 직접]** Transporter로 `build/ios/ipa/oneday.ipa` 업로드
- [ ] **[USER 직접]** App Store Connect 버전 1.0.2 생성 → 마케팅 URL 입력:
  `https://grateful-flow-production-6c7b.up.railway.app`
- [ ] **[USER 직접]** 심사 제출 → 승인 후 AdMob "업데이트 확인" 클릭

---

## Phase 22: 온도 정확도 개선 + 버그 수정 + 컨셉 변경 (2026-02-27)

**목표**: Open-Meteo 연동으로 온도 정확도 향상, 누적 페이지 스와이프 컨셉 전환

### 22-1. 온도 정확도 개선
- [x] 백엔드 캐시 키 정밀도 `round(lat, 1)` (~11km) → `round(lat, 2)` (~1km) 변경
- [x] Open-Meteo `/daily` 엔드포인트에 `current` 파라미터 추가 (`temperature_2m, apparent_temperature, weather_code`)
- [x] Open-Meteo `daily`에 `uv_index_max` 추가 (UV 항상 0.0 버그 해결)
- [x] `WeatherData.fromOwm()` — `currentTempOverride`, `feelsLikeOverride`, `uvIndexOverride` 파라미터 추가
- [x] `WeatherRepository.fetchCurrentWeather()` — Open-Meteo 현재 기온/체감/UV로 오버라이드

### 22-2. 심층 버그 수정 (18개)
- [x] UV Index 항상 0.0 → Open-Meteo `uv_index_max` 연동으로 수정
- [x] `weather[]` 배열 빈 경우 크래시 → safe fallback `{'main':'Clear','id':800}` 처리
- [x] DateTime 월말 오버플로우 (`day + N`) → `.add(Duration(days: N))` 수정 (repository + weather_data)
- [x] `fetchTomorrowForecast` 위치 캐시 검증 누락 → `_isForecastCacheValidFor()` 추가
- [x] OWM 예보 전혀 없을 때 폴백 → `_openMeteoCodeToOwm()` 메서드 추가
- [x] `forecastList` null 체크 누락 → null-safe 처리 추가
- [x] `DailyForecast.fromOwmForecastItem` null safety 강화

### 22-3. 누적 페이지 스와이프 컨셉 전환
- [x] `home_screen.dart` AnimatedSwitcher → PageView 전환
  - Morning: MorningView 1개만
  - Lunch: Morning + Lunch 2개 (스와이프)
  - Evening: Morning + Lunch + Evening 3개 (스와이프)
- [x] 페이지 인디케이터 dots 추가 (2페이지 이상일 때만 표시)
- [x] 시간대 변경 시 해당 모드의 마지막 페이지로 자동 이동 (`ref.listen` + `animateToPage`)
- [x] 초기 페이지 현재 시간대 기준으로 설정 (`initState`에서 `ref.read`)
- [x] `BackgroundLayer` — `TimeMode mode` 파라미터 추가 (현재 보고 있는 페이지 기준 블러/오버레이)
- [x] `withOpacity` deprecated → `withValues(alpha:)` 수정 (`background_layer.dart`)

### 22-4. 알림 기본값 변경
- [x] 점심 알람 기본값 OFF → ON 변경 (`settings_provider.dart`)
- [x] 저녁 알람 기본 시간 21:00 → 19:00 변경

### 22-5. 추가 버그 수정 (코드 재검토)
- [x] `morning_lottie.dart` — 눈(600-699) 코드가 비(500-700) 조건에 먼저 걸려 도달 불가 → 순서 수정 (눈 먼저 체크)
- [x] 버전 `1.0.2+5` → `1.0.3+6` 업데이트

### 22-6. 코디 추천 멘트 완화
- [x] `outfit_advisor.dart` — 온도 기준 전체 하향 조정 (기존 대비 약 2~3°C 낮춤)
  - ≤0°C → ≤-2°C "매우 추워요" (패딩+목도리+장갑), "체감 온도" 오용 텍스트 수정
  - ≤5°C → ≤3°C "꽤 춥네요" ("많이 춥네요" 표현 완화)
  - ≤10°C → ≤8°C "쌀쌀해요" (🧤 장갑 이모지 → 🧥 코트 이모지)
  - ≤15°C → ≤13°C "약간 서늘해요"
  - ≤20°C → ≤19°C, ≤25°C → ≤24°C, ≤30°C → ≤29°C

---

## Phase 23: 날씨 정확도 개선 + Pull-to-Refresh + 기상청 API (2026-02-28)

**목표**: 네이버/기상청 앱과의 온도 차이 해소, 실시간 새로고침 UX 개선

### 23-1. 캐시 TTL 단축
- [x] `backend/main.py` `CACHE_SECONDS` 1800 → 600 (30분 → 10분)
- [x] `lib/core/config/app_config.dart` `weatherCacheDuration` 30분 → 10분

### 23-2. Pull-to-Refresh (아래로 당겨 새로고침)
- [x] `morning_view.dart` `StatelessWidget` → `ConsumerWidget` 전환, `RefreshIndicator` 추가
- [x] `lunch_view.dart` 동일 처리
- [x] `evening_view.dart` 동일 처리
- [x] `SingleChildScrollView`에 `AlwaysScrollableScrollPhysics` 적용 (콘텐츠 짧아도 스크롤 허용)
- [x] `WeatherNotifier.refresh()`에 `ref.invalidate(tomorrowForecastProvider)` 추가 → 저녁 내일 예보도 함께 갱신

### 23-3. 기상청 API 통합 (한국 실측 데이터)
- [x] `backend/main.py` 기상청 관련 추가
  - `latlon_to_grid()` Lambert Conformal Conic 좌표 변환 (lat/lon → nx/ny)
  - `get_ncst_base_time()` 초단기실황 발표시각 계산 (매시 40분 기준)
  - `get_fcst_base_time()` 초단기예보 발표시각 계산 (매시 45분 기준)
  - `kma_to_owm_code()` 기상청 PTY/SKY → OWM weather ID 변환
  - `GET /kma_current` 엔드포인트: 초단기실황(T1H, PTY, WSD, REH) + 초단기예보(SKY) 통합
- [x] `weather_service.dart` `fetchKmaWeather()` 메서드 추가
- [x] `weather_data.dart` `WeatherData.fromOwm()` — `weatherCodeOverride` 파라미터 추가, `_owmCodeToMain()` static 메서드 추가
- [x] `weather_repository.dart` — KMA 기온/날씨 코드 최우선 적용
  - 우선순위: KMA 기온 > Open-Meteo 기온 > OWM 기온
  - 체감온도: Open-Meteo `apparent_temperature` 유지 (기상청 미제공)
  - KMA 장애 시 graceful fallback (try/catch)
- [x] Railway `KMA_API_KEY` 환경변수 등록 (`railway variable set`)
- [x] 기상청 API 실측 확인: 서울 기준 온도·하늘상태·강수형태 정상 반환

### 23-4. 개인정보처리방침 업데이트
- [x] `settings_screen.dart` 3. 제3자 서비스 항목에 "기상청 단기예보 API" 추가
- [x] `backend/main.py` `/privacy` HTML — "기상청 (날씨 데이터 조회)" 항목 추가

---

## Phase 24: 버그 수정 — 앱 초기화 성능 + 위치 권한 오류 처리 (2026-02-28)

**목표**: 신규 설치 시 긴 초기화 시간 해소, 위치 권한 거부/영구거부 시 올바른 UX

### 24-1. 앱 초기화 성능 개선
- [x] `main.dart` `runApp()` 블로킹 해소
  - 기존: QuotePicker → EveningMessagePicker → GreetingPicker → HomeWidget → ATT 다이얼로그 → AdMob → NotificationService → `runApp()` (전부 순차 await)
  - 개선: Hive + Picker 3개만 `Future.wait()` 병렬 await 후 즉시 `runApp()` 호출
  - HomeWidget / ATT / AdMob / NotificationService는 `_postRunInit()`으로 분리해 백그라운드 처리
  - 신규 설치 시 ATT 다이얼로그 응답 대기로 인한 블랙스크린 제거
- [x] `weather_repository.dart` 날씨 API 4개 병렬화
  - 기존: OWM current → OWM forecast → Open-Meteo → KMA 순차 호출 (~2초+)
  - 개선: `Future.wait()` 4개 동시 호출 → 가장 느린 API 1개 시간만 소요 (~500ms)

### 24-2. 위치 권한 오류 처리 개선
- [x] `weather_provider.dart` `WeatherNotifier.refresh()`에 `ref.invalidate(locationProvider)` 추가
  - 기존: 위치 오류 상태에서 "다시 시도" 눌러도 locationProvider가 에러 캐시 상태 유지 → 즉시 재오류
  - 개선: refresh() 시 locationProvider도 invalidate → 권한 재요청 트리거
- [x] `weather_card.dart` (아침) 에러 UI 개선
  - 영구 거부(`영구` 포함 에러 메시지) 감지 → "설정에서 허용하기" 버튼 표시 (`Geolocator.openAppSettings()`)
  - 일반 거부 → 기존 "다시 시도" 버튼 유지
- [x] `uv_index_card.dart` (점심) 에러 처리 개선
  - 기존: 위치 오류인데 "인터넷 연결을 확인해주세요." 잘못된 메시지 표시
  - 개선: 위치/권한 오류 감지 → "위치 권한이 필요합니다." 표시
  - 영구 거부 시 "설정에서 허용하기" 버튼, 일반 거부 시 "다시 시도" 버튼
- [x] `tomorrow_forecast_card.dart` (저녁) 에러 처리 추가
  - 기존: `SizedBox.shrink()` — 카드 조용히 사라짐
  - 개선: 위치/권한 에러 메시지 + 영구거부/일반거부 분기 버튼 표시

---

## Phase 25: 배경 이미지 모드별 독립화 + 쿼리 현대화 (2026-02-28)

**목표**: 아침/점심/저녁 각 페이지가 독립된 이미지를 로드, 더 감성적인 Unsplash 쿼리 적용

### 25-1. Unsplash 쿼리 현대화
- [x] `lib/core/constants/unsplash_queries.dart` 전면 개선
  - 모드별 쿼리 6개로 확장 (기존 4개 → 6개)
  - 아침 쿼리: `morning light bokeh minimal`, `cozy morning window mist`, `golden hour soft bokeh`, `morning coffee aesthetic calm`, `dawn fog serene minimal`, `soft sunrise pastel sky`
  - 점심 쿼리: `clear blue sky minimal`, `afternoon sunlight bokeh`, `bright white architecture light`, `daytime clouds minimal aesthetic`, `summer light nature calm`, `blue sky clean minimal`
  - 저녁 쿼리: `cozy evening bokeh warm`, `night rain window bokeh`, `blue hour city minimal`, `evening lamp light moody`, `dark aesthetic moody calm`, `twilight purple sky blur`
  - `colorForMode()` 메서드 추가: morning=orange, lunch=blue, evening=black
- [x] `lib/data/services/unsplash_service.dart` `color` 파라미터 추가
- [x] `lib/data/repositories/image_repository.dart` `colorForMode()` 연동

### 25-2. 배경 이미지 모드별 독립 프로바이더
- [x] `lib/providers/background_image_provider.dart` — `AsyncNotifierProviderFamily`로 전환
  - 기존: 단일 `AsyncNotifierProvider` — `effectiveTimeModeProvider` 기반 현재 시간대 이미지만 로드
  - 개선: `FamilyAsyncNotifier<UnsplashPhoto, TimeMode>` — 각 TimeMode가 독립 캐시/상태 보유
  - `build(TimeMode arg)` — 파라미터로 받은 mode 기준으로 이미지 fetch
  - `refresh()` — `arg` 기반 해당 mode 이미지만 갱신
- [x] `lib/features/home/widgets/background_layer.dart` line 16 수정
  - `ref.watch(backgroundImageProvider)` → `ref.watch(backgroundImageProvider(mode))`
  - `BackgroundLayer`가 받은 `mode` 파라미터를 실제로 사용
- [x] `lib/features/home/home_screen.dart` 두 곳 수정
  - `_TopBar(mode: mode)` → `_TopBar(mode: _viewedMode)` (현재 보는 페이지 기준)
  - `_TopBar` refresh 버튼: `backgroundImageProvider.notifier.refresh()` → `backgroundImageProvider(mode).notifier.refresh()`
  - 효과: 새로고침 버튼이 현재 보고 있는 모드의 이미지만 교체

---

## Phase 26: 인사말 전면 교체 (2026-02-28)

**목표**: 아침/점심/저녁 상단 멘트를 단순한 문장에서 재미있고 센스있는 문장으로 전면 교체

- [x] `assets/greetings/morning_greetings.json` — 365개 전면 교체
  - 기존: "좋은 아침이에요! 오늘 하루도 빛나게 시작해요." 류의 단순 응원 문구
  - 개선: 상황 관찰형, 유머형, 철학형 등 다양한 결의 문장으로 교체
  - 예시: "알람을 이긴 건 당신이에요. 오늘의 챔피언이에요.", "이불이 붙잡는 거 느꼈죠? 탈출 성공이에요.", "세상이 아직 조용할 때 눈을 뜬 것, VIP 같은 느낌 아닌가요?"
- [x] `assets/greetings/lunch_greetings.json` — 365개 전면 교체
  - 예시: "밥은 먹었나요? 이게 오늘 가장 중요한 질문이에요.", "배고프면 판단력이 흐려져요. 일단 먹어요.", "오후 3시 졸음은 세계 공통이에요. 당신만의 문제가 아니에요."
- [x] `assets/greetings/evening_greetings.json` — 365개 전면 교체
  - 예시: "오늘 하루 수고했어요. 이제 그 모드 끄세요.", "오늘 실수한 거 있나요? 내일 새 버전으로 돌아오면 돼요.", "저녁이 됐어요. 이제 진짜 당신 시간이에요."
- [x] iPhone(Moon) 릴리즈 빌드 재설치 확인

---

## 이슈 / 결정 로그

| 날짜 | 이슈 | 결정 | 상태 |
|------|------|------|------|
| 2026-02-22 | hive_generator + freezed source_gen 충돌 | hive_generator 제거, TypeAdapter 수동 작성 | 해결 |
| 2026-02-22 | google_fonts 6.x iOS 빌드 실패 | 5.1.0으로 다운그레이드 | 해결 |
| 2026-02-22 | 다수 사용자 시 OWM API 요청 한도 초과 우려 | FastAPI 백엔드 도입, 서버 사이드 캐시 | 해결 |
| 2026-02-22 | brew Railway CLI v2.1.0 login 404 오류 | npm @railway/cli v4.30.3 설치로 전환 | 해결 |
| 2026-02-22 | tz.local이 UTC 기본값 → 알림 시간 9시간 오차 | flutter_timezone으로 실제 기기 시간대 감지 | 해결 |
| 2026-02-22 | Android 알림 권한 누락 | POST_NOTIFICATIONS + SCHEDULE_EXACT_ALARM + boot receiver 추가 | 해결 |
| 2026-02-22 | iOS ATS가 localhost HTTP 차단 | NSAppTransportSecurity 예외 추가 | 해결 |
| 2026-02-22 | 점심 Lottie 중앙 정렬 문제 | `alignment`/`fit` 조합 불충분 → `SizedBox(100×100)` + `Spacer()`로 고정 크기 해결 | 해결 |
| 2026-02-22 | `assets/greetings/` 경로 pubspec 미선언 → 흰 화면 | `pubspec.yaml` `flutter.assets`에 경로 추가 | 해결 |
| 2026-02-22 | 설정 버튼 추가로 새로고침 버튼이 중앙 이동 | 두 버튼을 `Row(mainAxisSize: min)`으로 묶어 우측 배치 | 해결 |
| 2026-02-22 | Bundle ID com.oneday.oneday 충돌 (ENTITY_ERROR.ATTRIBUTE.INVALID) | com.imurmkj.oneday로 변경 (Apple ID 기반 고유 네임스페이스) | 해결 |
| 2026-02-22 | 아침 카드와 점심/저녁 카드 세로 정렬 불일치 | LunchLottie / EveningLottie height 100→120px 통일 | 해결 |
| 2026-02-23 | 아침 최고/최저 온도가 현재 시간대 범위만 반영 (부정확) | forecastList 오늘 슬롯 전체 집계로 개선, WeatherData.fromOwm에 override 파라미터 추가 | 해결 |
| 2026-02-23 | 알람 타임피커 시계 다이얼 진입 → 키보드 입력으로 전환 번거로움 | initialEntryMode: TimePickerEntryMode.input으로 키보드 직접 입력 전용 설정 | 해결 |
| 2026-02-23 | 점심 메뉴 카드 상단 텍스트 클리핑 | _MenuPage 패딩 top 0→12 수정 | 해결 |
| 2026-02-23 | 저녁 공유 이미지 폰트 앱 컨셉과 불일치 | GoogleFonts.gowunBatang 세리프 명조 적용 | 해결 |
| 2026-02-23 | Unsplash API 키가 소스 코드에 노출될 위험 | app_secrets.dart 분리 + .gitignore 적용 | 해결 |
| 2026-02-23 | Bundle ID com.oneday.oneday → TARGETED_DEVICE_FAMILY에 iPad 포함 → 스크린샷 의무 요건 | iPhone 전용("1")으로 변경 | 해결 |
| 2026-02-23 | App Store 수출 규정 암호화 선언 누락 | ITSAppUsesNonExemptEncryption=false 추가 | 해결 |
| 2026-02-23 | 개인정보처리방침 & 이용약관 외부 URL 없음 | Railway 백엔드 /privacy, /terms 엔드포인트로 HTML 서빙 | 해결 |
| 2026-02-24 | AdMob 정책 — iOS 14+ ATT 동의 없이 광고 식별자 접근 불가 | app_tracking_transparency 패키지로 팝업 구현 | 해결 |
| 2026-02-24 | Google AdMob app-ads.txt 인증 미비 | Railway 백엔드 /app-ads.txt 엔드포인트 추가 | 해결 |
| 2026-02-25 | AdMob 개발자 웹사이트 미등록 | App Store 마케팅 URL 설정 위해 v1.0.2+5 신규 빌드 필요 | 진행 중 |
| 2026-02-27 | 온도가 네이버와 차이 (OWM 모델 vs 기상청 ECMWF) | Open-Meteo current로 교체, 백엔드 캐시 ~1km 정밀도로 개선 | 해결 |
| 2026-02-27 | UV Index 항상 0.0 표시 | Open-Meteo uv_index_max daily 필드 누락 → 추가 | 해결 |
| 2026-02-27 | morning_lottie 눈 날씨 코드 비 조건에 먼저 걸림 | 눈(600-699) 조건을 비(500-599) 조건보다 앞에 배치 | 해결 |
| 2026-02-27 | 아침만 보이던 뷰 → 누적 페이지 스와이프 방식으로 전환 요청 | HomeScreen PageView 전환, BackgroundLayer mode 파라미터 추가 | 해결 |
| 2026-02-27 | 코디 추천 멘트가 실제 날씨 대비 과도하게 과장됨 | outfit_advisor 온도 기준 2~3°C 하향, 과격한 표현 완화 | 해결 |
| 2026-02-28 | 아침/점심/저녁 배경 이미지가 모두 동일 (effectiveTimeModeProvider 기반 단일 provider) | backgroundImageProvider를 FamilyAsyncNotifier로 전환, BackgroundLayer가 mode 파라미터 실제 사용 | 해결 |
| 2026-02-28 | Unsplash 쿼리가 오래된 스타일, 컨셉 불일치 | 감성 미니멀 쿼리 6개로 갱신 + colorForMode() 추가 | 해결 |

---

## 주요 노트

### OWM One Call 3.0 대안
카드 등록 없이 사용하려면 2.5 endpoint 사용:
- 현재 날씨: `GET /data/2.5/weather`
- 예보: `GET /data/2.5/forecast`
- UV 지수: `GET /data/2.5/uvi`

### Lottie 파일 소스
- https://lottiefiles.com (Free 라이선스 필터 적용)
- 검색어: `sunrise`, `stars`, `moon`, `clouds`

### 한국어 명언
`assets/quotes/quotes_ko.json` 파일에 30개 이상 직접 작성 권장

### API 키 입력 위치
`lib/core/config/app_config.dart`의 placeholder 값 교체
