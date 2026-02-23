import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/outfit_advisor.dart';

void main() {
  group('OutfitAdvisor.getAdvice - 온도 구간', () {
    test('0도 이하 → 패딩 + 목도리 + 장갑', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: -5,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('패딩'));
    });

    test('5도 이하 → 두꺼운 코트', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 3,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('코트'));
    });

    test('10도 이하 → 자켓이나 가디건', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 8,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('자켓'));
    });

    test('15도 이하 → 얇은 자켓', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 13,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('얇은 자켓'));
    });

    test('20도 이하 → 긴팔', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 18,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('긴팔'));
    });

    test('25도 이하 → 쾌적한 날씨', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 22,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('쾌적'));
    });

    test('30도 이하 → 더운 날, 반팔', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 28,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('반팔'));
    });

    test('30도 초과 → 매우 더워요', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 35,
        weatherMain: 'Clear',
        rainProbPercent: 0,
      );
      expect(advice, contains('매우 더워요'));
    });
  });

  group('OutfitAdvisor.getAdvice - 날씨 조건', () {
    test('Snow → 눈 주의 메시지', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 0,
        weatherMain: 'Snow',
        rainProbPercent: 0,
      );
      expect(advice, contains('눈이 와요'));
    });

    test('snow 소문자도 인식', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: -2,
        weatherMain: 'snow',
        rainProbPercent: 0,
      );
      expect(advice, contains('눈이 와요'));
    });
  });

  group('OutfitAdvisor.getAdvice - 강수 확률', () {
    test('29% → 우산 언급 없음', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 20,
        weatherMain: 'Clouds',
        rainProbPercent: 29,
      );
      expect(advice, isNot(contains('우산')));
    });

    test('30% → 가벼운 우산', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 20,
        weatherMain: 'Clouds',
        rainProbPercent: 30,
      );
      expect(advice, contains('가벼운 우산'));
    });

    test('60% → 우산을 꼭 챙기세요', () {
      final advice = OutfitAdvisor.getAdvice(
        currentTemp: 20,
        weatherMain: 'Rain',
        rainProbPercent: 60,
      );
      expect(advice, contains('우산을 꼭 챙기세요'));
    });
  });

  group('OutfitAdvisor.uvDescription', () {
    test('UV 2 → 낮음', () => expect(OutfitAdvisor.uvDescription(2), '낮음'));
    test('UV 4 → 보통', () => expect(OutfitAdvisor.uvDescription(4), '보통'));
    test('UV 7 → 높음', () => expect(OutfitAdvisor.uvDescription(7), '높음'));
    test('UV 9 → 매우 높음', () => expect(OutfitAdvisor.uvDescription(9), '매우 높음'));
    test('UV 11 → 위험', () => expect(OutfitAdvisor.uvDescription(11), '위험'));
  });

  group('OutfitAdvisor.uvAdvice', () {
    test('UV 2 → 야외 활동 좋은 날', () {
      expect(OutfitAdvisor.uvAdvice(2), contains('야외 활동'));
    });
    test('UV 9 → 피부 보호 주의', () {
      expect(OutfitAdvisor.uvAdvice(9), contains('피부 보호'));
    });
    test('UV 11 → 외출 자제', () {
      expect(OutfitAdvisor.uvAdvice(11), contains('외출을 자제'));
    });
  });
}
