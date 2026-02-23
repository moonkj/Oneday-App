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

- [ ] 개인정보처리방침 URL 생성 (GitHub Pages / Notion 공개 페이지)
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
