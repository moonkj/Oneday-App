import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/utils/greeting_picker.dart';

void main() {
  group('GreetingPicker - fallback (초기화 없이 호출)', () {
    // _messages 리스트가 null이거나 비어있을 때 기본 문자열 반환
    test('morningGreeting fallback은 non-empty', () {
      final msg = GreetingPicker.morningGreeting();
      expect(msg, isNotEmpty);
    });

    test('lunchGreeting fallback은 non-empty', () {
      final msg = GreetingPicker.lunchGreeting();
      expect(msg, isNotEmpty);
    });

    test('eveningGreeting fallback은 non-empty', () {
      final msg = GreetingPicker.eveningGreeting();
      expect(msg, isNotEmpty);
    });
  });

  group('GreetingPicker - 초기화 후 (tester.runAsync + rootBundle)', () {
    testWidgets('initialize() 후 morningGreeting이 non-empty', (tester) async {
      // tester.runAsync: 실제 async I/O(rootBundle) 허용
      await tester.runAsync(() async {
        await GreetingPicker.initialize();
      });
      expect(GreetingPicker.morningGreeting(), isNotEmpty);
    });

    testWidgets('같은 날 두 번 호출 시 동일한 메시지 (결정론적)', (tester) async {
      await tester.runAsync(() async {
        await GreetingPicker.initialize();
      });
      final msg1 = GreetingPicker.morningGreeting();
      final msg2 = GreetingPicker.morningGreeting();
      expect(msg1, msg2);
    });

    testWidgets('lunchGreeting, eveningGreeting도 non-empty', (tester) async {
      await tester.runAsync(() async {
        await GreetingPicker.initialize();
      });
      expect(GreetingPicker.lunchGreeting(), isNotEmpty);
      expect(GreetingPicker.eveningGreeting(), isNotEmpty);
    });
  });
}
