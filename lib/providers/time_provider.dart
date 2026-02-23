import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/extensions/datetime_extensions.dart';
import 'package:oneday/data/models/time_mode.dart';

/// 60초마다 현재 TimeMode를 스트림으로 방출
final timeModeStreamProvider = StreamProvider<TimeMode>((ref) async* {
  yield DateTime.now().timeMode;
  yield* Stream.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now().timeMode,
  );
});

/// 동기 파생 프로바이더 - 모든 하위 프로바이더가 이것을 watch
final currentTimeModeProvider = Provider<TimeMode>((ref) {
  return ref.watch(timeModeStreamProvider).valueOrNull ?? TimeMode.morning;
});

/// 앱에서 사용하는 TimeMode
final effectiveTimeModeProvider = Provider<TimeMode>((ref) {
  return ref.watch(currentTimeModeProvider);
});
