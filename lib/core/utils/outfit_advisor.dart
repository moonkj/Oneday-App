/// 온도 및 날씨 기반 코디 조언 생성 (순수 함수)
abstract class OutfitAdvisor {
  static String getAdvice({
    required double currentTemp,
    required String weatherMain,
    required int rainProbPercent,
  }) {
    final buffer = StringBuffer();

    // 날씨 조건별 조언
    if (rainProbPercent >= 60) {
      buffer.write('비가 올 확률이 높아요. 우산을 꼭 챙기세요! ☔ ');
    } else if (rainProbPercent >= 30) {
      buffer.write('가벼운 우산을 챙기면 좋을 것 같아요. ☂️ ');
    }

    if (weatherMain.toLowerCase() == 'snow') {
      buffer.write('눈이 와요. 미끄럼에 주의하고 방한 장갑을 챙기세요. 🧤 ');
    }

    // 기온별 조언
    if (currentTemp <= -2) {
      buffer.write('매우 추워요. 패딩과 목도리, 장갑까지 꼭 챙기세요. 🧥');
    } else if (currentTemp <= 3) {
      buffer.write('꽤 춥네요. 두꺼운 코트와 목도리를 착용하세요. 🧣');
    } else if (currentTemp <= 8) {
      buffer.write('쌀쌀해요. 자켓이나 코트를 입으세요. 🧥');
    } else if (currentTemp <= 13) {
      buffer.write('약간 서늘해요. 얇은 자켓이나 가디건 하나면 딱이에요. 👕');
    } else if (currentTemp <= 19) {
      buffer.write('선선한 날씨예요. 긴팔에 가벼운 겉옷을 준비하세요. 👔');
    } else if (currentTemp <= 24) {
      buffer.write('쾌적한 날씨예요. 얇은 긴팔이나 반팔이 좋아요. 😊');
    } else if (currentTemp <= 29) {
      buffer.write('더운 날이에요. 시원한 반팔 차림으로 나가세요. ☀️');
    } else {
      buffer.write('매우 더워요! 가능한 시원하게 입고 수분 보충을 자주 하세요. 🌡️');
    }

    return buffer.toString().trim();
  }

  /// UV 지수별 설명
  static String uvDescription(double uvIndex) {
    if (uvIndex < 3) return '낮음';
    if (uvIndex < 6) return '보통';
    if (uvIndex < 8) return '높음';
    if (uvIndex < 11) return '매우 높음';
    return '위험';
  }

  static String uvAdvice(double uvIndex) {
    if (uvIndex < 3) return '야외 활동하기 좋은 날이에요.';
    if (uvIndex < 6) return '선크림을 바르고 나가세요.';
    if (uvIndex < 8) return '자외선이 강해요. 모자와 선글라스를 챙기세요.';
    if (uvIndex < 11) return '자외선이 매우 강해요. 피부 보호에 주의하세요.';
    return '자외선이 위험 수준이에요. 외출을 자제해 주세요.';
  }
}
