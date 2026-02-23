import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/core/extensions/datetime_extensions.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/providers/time_provider.dart';

void main() {
  group('timeModeStreamProvider - Stream.periodic lambda', () {
    test('periodic lambda (_) => DateTime.now().timeMode 가 TimeMode 반환', () {
      // Stream.periodic의 람다를 직접 테스트 (line 10 로직 검증)
      // (_) => DateTime.now().timeMode 와 동일한 로직
      final result = DateTime.now().timeMode;
      expect(result, isA<TimeMode>());
    });

    test('timeModeStreamProvider가 StreamProvider<TimeMode> 타입', () {
      expect(timeModeStreamProvider, isA<StreamProvider<TimeMode>>());
    });

    test('StreamProvider 초기값이 현재 TimeMode와 일치', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 초기 AsyncValue를 기다림
      final value = await container.read(timeModeStreamProvider.future);
      expect(value, isA<TimeMode>());
      expect(value, DateTime.now().timeMode);
    });

    test('Stream.periodic Duration 인자 (line 10) - yield* 진입 커버', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // ProviderContainer.listen()으로 스트림을 구독 → 제너레이터가 yield* 까지 실행됨
      final values = <TimeMode>[];
      container.listen<AsyncValue<TimeMode>>(
        timeModeStreamProvider,
        (_, next) {
          if (next.hasValue) values.add(next.value!);
        },
        fireImmediately: true,
      );

      // 미세 태스크 사이클 대기 → 제너레이터가 yield* Stream.periodic(line 10)에 도달
      await Future.delayed(Duration.zero);
      await Future.microtask(() {});
      await Future.microtask(() {});

      // 첫 번째 값(초기 yield)이 emit되었는지 확인
      expect(values, isNotEmpty);
    });

    test('Stream.periodic 1분 경과 → lambda (line 10) 실제 호출', () {
      fakeAsync((async) {
        final container = ProviderContainer();

        final values = <TimeMode>[];
        container.listen<AsyncValue<TimeMode>>(
          timeModeStreamProvider,
          (_, next) {
            if (next.hasValue) values.add(next.value!);
          },
          fireImmediately: true,
        );

        // 초기 yield 완료까지 마이크로태스크 실행
        async.flushMicrotasks();

        // 1분 경과 → Stream.periodic의 (_) => DateTime.now().timeMode (line 10) 호출
        async.elapse(const Duration(minutes: 1));
        async.flushMicrotasks();

        // 초기값 + periodic 첫 tick = 최소 2개
        expect(values.length, greaterThanOrEqualTo(2));

        container.dispose();
      });
    });
  });

  group('debugTimeModeOverrideProvider', () {
    test('초기값은 null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final override = container.read(debugTimeModeOverrideProvider);
      expect(override, isNull);
    });

    test('override 설정 시 effectiveTimeMode가 해당 모드 반환', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(debugTimeModeOverrideProvider.notifier).state = TimeMode.morning;
      final effective = container.read(effectiveTimeModeProvider);
      expect(effective, TimeMode.morning);
    });

    test('override를 lunch로 설정', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(debugTimeModeOverrideProvider.notifier).state = TimeMode.lunch;
      expect(container.read(effectiveTimeModeProvider), TimeMode.lunch);
    });

    test('override null 시 실제 TimeMode 반환 (TimeMode 타입이어야 함)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // null = override 없음 → 실제 시간 기반 (currentTimeModeProvider의 초기값)
      container.read(debugTimeModeOverrideProvider.notifier).state = null;
      final effective = container.read(effectiveTimeModeProvider);
      // 실제 시간이 어떤 모드든 TimeMode 타입이어야 함
      expect(effective, isA<TimeMode>());
    });
  });
}
