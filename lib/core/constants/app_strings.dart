/// 앱 전체 한국어 UI 문자열 (중앙 관리)
abstract class AppStrings {
  // --- 앱 공통 ---
  static const appName = 'One Day';
  static const loadingMessage = '잠시만요...';
  static const errorRetry = '다시 시도';
  static const networkError = '인터넷 연결을 확인해주세요.';
  static const locationError = '위치 정보를 가져올 수 없어요.';
  static const locationPermissionDenied = '위치 권한이 필요합니다.\n설정에서 허용해 주세요.';

  // --- Morning 모드 ---
  static const morningGreetingEarly = '좋은 이른 아침이에요! 🌅\n상쾌한 하루의 시작이네요.';
  static const morningGreetingMid = '좋은 아침이에요! ☀️\n오늘도 멋진 하루 보내세요.';
  static const morningGreetingLate = '안녕하세요! 🌤️\n활기찬 오전이 되길 바랍니다.';

  static const morningGreetingRainy = '비 오는 아침이네요. ☔\n우산 챙기는 거 잊지 마세요!';
  static const morningGreetingSnowy = '눈이 내리는 아침이에요! ❄️\n따뜻하게 입고 나가세요.';
  static const morningGreetingCloudy = '흐린 아침이에요. ☁️\n그래도 좋은 하루 될 거예요!';

  static const weatherCurrentTemp = '현재 기온';
  static const weatherFeelsLike = '체감 온도';
  static const weatherHigh = '최고';
  static const weatherLow = '최저';
  static const weatherRainChance = '강수 확률';
  static const weatherUvIndex = '자외선';

  static const outfitAdviceTitle = '오늘의 코디 추천';

  // --- Lunch 모드 ---
  static const lunchGreeting = '점심 시간이에요! ☀️\n잠깐 쉬어 가는 건 어떠세요?';
  static const lunchAfternoonGreeting = '오후도 힘내세요! 💪\n이제 절반을 지났어요.';
  static const uvLow = '낮음';
  static const uvModerate = '보통';
  static const uvHigh = '높음';
  static const uvVeryHigh = '매우 높음';
  static const uvExtreme = '위험';
  static const uvAdviceLow = '야외 활동하기 좋은 날이에요.';
  static const uvAdviceModerate = '선크림을 바르고 나가세요.';
  static const uvAdviceHigh = '자외선이 강해요. 모자와 선글라스를 챙기세요.';
  static const uvAdviceVeryHigh = '자외선이 매우 강해요. 피부 보호에 주의하세요.';
  static const uvAdviceExtreme = '자외선이 위험 수준이에요. 외출을 자제해 주세요.';

  static const lunchReminderMessages = [
    '커피 한 잔의 여유, 어떠세요? ☕',
    '오후 업무도 화이팅! 당신을 응원해요.',
    '잠깐 스트레칭으로 몸을 풀어주세요. 🙆',
    '물 한 잔 마시는 거 잊지 마세요! 💧',
    '오늘 점심은 맛있게 드셨나요? 😋',
    '창밖을 보며 잠깐 눈을 쉬어주세요. 👀',
  ];

  static const quoteTitle = '오늘의 한 마디';

  // --- Evening 모드 ---
  static const eveningGreeting = '오늘 하루도 정말 수고하셨어요. 🌙\n편안한 밤 보내세요.';
  static const eveningGreetingMidnight = '늦은 밤까지 애쓰셨군요. ⭐\n이제 쉬어도 괜찮아요.';

  static const tomorrowForecast = '내일 날씨 예보';
  static const tomorrowPreview = '내일은';
  static const recordTitle = '오늘의 한 문장';
  static const recordHint = '오늘 하루를 한 문장으로 남겨보세요...';
  static const recordSave = '기록 저장';
  static const recordSaveSuccess = '오늘의 기록이 저장되었어요 ✨';
  static const recordSaveFail = '저장에 실패했어요. 다시 시도해주세요.';

  static const saveImageButton = '갤러리에 저장';
  static const saveImageSuccess = '이미지가 갤러리에 저장되었어요 📸';
  static const saveImageFail = '이미지 저장에 실패했어요.';
  static const saveImagePermissionDenied = '사진 저장 권한이 필요합니다.\n설정에서 허용해 주세요.';

  // --- 날씨 상태 한국어 ---
  static String weatherCondition(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return '맑음';
      case 'clouds':
        return '흐림';
      case 'rain':
        return '비';
      case 'drizzle':
        return '이슬비';
      case 'thunderstorm':
        return '뇌우';
      case 'snow':
        return '눈';
      case 'mist':
      case 'fog':
      case 'haze':
        return '안개';
      default:
        return main;
    }
  }
}
