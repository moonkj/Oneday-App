import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/evening_message_picker.dart';

void main() {
  // ── catch 블록 커버: rootBundle 로드 실패 시 fallback 3개 위로 메시지 ──────

  group('EveningMessagePicker - initialize() 에셋 로드 실패', () {
    testWidgets('catch 블록: 3개 위로 메시지 fallback으로 초기화됨', (tester) async {
      // flutter/assets 채널을 가로채 빈 ByteData 반환 → loadString이 FormatException
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (_) async => ByteData(0),
      );

      await tester.runAsync(() async {
        await EveningMessagePicker.initialize();
      });

      // 복원
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        null,
      );

      // catch 블록 실행: _messages = [수고, 최선, 쉬어도] 3개 세팅
      // todayMessage()는 null이 아니므로 3개 중 하나 반환
      final msg = EveningMessagePicker.todayMessage();
      expect(msg, isNotEmpty);
    });
  });
}
