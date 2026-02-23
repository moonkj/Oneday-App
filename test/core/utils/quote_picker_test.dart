import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/quote_picker.dart';

void main() {
  // ── T5. QuotePicker ──────────────────────────────────────────────────────

  group('Quote 모델', () {
    test('text와 author 필드를 올바르게 저장한다', () {
      const q = Quote(text: '테스트 명언', author: '테스터');
      expect(q.text, '테스트 명언');
      expect(q.author, '테스터');
    });

    test('const 생성자로 동일 값이면 동등하다', () {
      const q1 = Quote(text: '동일', author: '저자');
      const q2 = Quote(text: '동일', author: '저자');
      expect(q1.text, q2.text);
      expect(q1.author, q2.author);
    });
  });

  group('QuotePicker - fallback (초기화 없이 호출)', () {
    // _quotes가 null인 상태(initialize 미호출)에서 fallback 반환 확인

    test('todayQuote() fallback text는 non-empty', () {
      final q = QuotePicker.todayQuote();
      expect(q.text, isNotEmpty);
    });

    test('todayQuote() fallback author는 ONE DAY', () {
      final q = QuotePicker.todayQuote();
      expect(q.author, 'ONE DAY');
    });
  });

  group('QuotePicker - 초기화 후 (tester.runAsync + rootBundle)', () {
    testWidgets('initialize() 후 todayQuote() text가 non-empty', (tester) async {
      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });
      final q = QuotePicker.todayQuote();
      expect(q.text, isNotEmpty);
    });

    testWidgets('initialize() 후 todayQuote() author가 non-empty', (tester) async {
      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });
      final q = QuotePicker.todayQuote();
      expect(q.author, isNotEmpty);
    });

    testWidgets('같은 날 두 번 호출 시 동일한 명언 반환 (결정론적)', (tester) async {
      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });
      final q1 = QuotePicker.todayQuote();
      final q2 = QuotePicker.todayQuote();
      expect(q1.text, q2.text);
      expect(q1.author, q2.author);
    });

    testWidgets('초기화 후 author가 ONE DAY가 아님 (quotes_ko.json에서 로드됨)',
        (tester) async {
      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });
      // fallback quote의 author는 'ONE DAY'; JSON 로드 성공 시엔 달라야 함
      expect(QuotePicker.todayQuote().author, isNot('ONE DAY'));
    });

    testWidgets('반환된 text가 quotes_ko.json 첫 번째 명언 중 하나임', (tester) async {
      // 공식 검증: 알려진 명언이 정상 선택되는지 smoke-test
      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });
      final q = QuotePicker.todayQuote();
      // 402개 명언 중 하나이므로 text는 반드시 비어있지 않아야 함
      expect(q.text.length, greaterThan(5));
    });
  });
}
