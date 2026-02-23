import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/quote_picker.dart';

void main() {
  // ── catch 블록 커버: rootBundle 로드 실패 시 fallback 3개 유명인 명언 ──────

  group('QuotePicker - initialize() 에셋 로드 실패', () {
    testWidgets('catch 블록: 3개 유명인 명언 fallback으로 초기화됨', (tester) async {
      // flutter/assets 채널을 가로채 빈 ByteData 반환 → loadString이 FormatException
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (_) async => ByteData(0), // 빈 응답 → 파싱 오류 유발
      );

      await tester.runAsync(() async {
        await QuotePicker.initialize();
      });

      // 복원
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        null,
      );

      // catch 블록 실행: _quotes = [아인슈타인, 포드, 디즈니] 3개 세팅
      // todayQuote()는 null이 아니므로 3개 중 하나 반환
      final q = QuotePicker.todayQuote();
      expect(q.text, isNotEmpty);
      // ONE DAY는 _quotes == null일 때의 fallback; catch 이후엔 유명인 명언
      expect(q.author, isNot('ONE DAY'));
    });
  });
}
