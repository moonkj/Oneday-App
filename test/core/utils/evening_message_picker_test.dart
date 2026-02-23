import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/evening_message_picker.dart';

void main() {
  // ── T6. EveningMessagePicker ─────────────────────────────────────────────

  group('EveningMessagePicker - fallback (초기화 없이 호출)', () {
    // _messages가 null인 상태(initialize 미호출)에서 fallback 반환 확인

    test('todayMessage() fallback은 non-empty', () {
      final msg = EveningMessagePicker.todayMessage();
      expect(msg, isNotEmpty);
    });

    test('todayMessage() fallback은 수고 위로 문구를 포함한다', () {
      final msg = EveningMessagePicker.todayMessage();
      // hardcoded fallback: '오늘 하루도 정말 수고하셨어요. 편안한 밤 보내세요.'
      expect(msg, contains('수고'));
    });
  });

  group('EveningMessagePicker - 초기화 후 (tester.runAsync + rootBundle)', () {
    testWidgets('initialize() 후 todayMessage()가 non-empty', (tester) async {
      await tester.runAsync(() async {
        await EveningMessagePicker.initialize();
      });
      expect(EveningMessagePicker.todayMessage(), isNotEmpty);
    });

    testWidgets('같은 날 두 번 호출 시 동일한 메시지 반환 (결정론적)', (tester) async {
      await tester.runAsync(() async {
        await EveningMessagePicker.initialize();
      });
      final msg1 = EveningMessagePicker.todayMessage();
      final msg2 = EveningMessagePicker.todayMessage();
      expect(msg1, msg2);
    });
  });
}
