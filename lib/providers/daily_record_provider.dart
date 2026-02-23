import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/data/models/daily_record.dart';
import 'package:oneday/data/repositories/daily_record_repository.dart';
import 'package:oneday/providers/weather_provider.dart';

final dailyRecordRepositoryProvider = Provider<DailyRecordRepository>((ref) {
  return DailyRecordRepository();
});

class DailyRecordNotifier extends Notifier<DailyRecord> {
  @override
  DailyRecord build() {
    final repo = ref.watch(dailyRecordRepositoryProvider);
    return repo.loadToday() ?? DailyRecord.empty(DateTime.now());
  }

  void updateSentence(String text) {
    state = state.copyWith(sentence: text);
  }

  Future<bool> saveRecord() async {
    try {
      final weatherAsync = ref.read(weatherNotifierProvider);
      final weather = weatherAsync.valueOrNull;

      final record = state.copyWith(
        tempCurrent: weather?.tempCurrent,
        tempMax: weather?.tempMax,
        tempMin: weather?.tempMin,
        weatherMain: weather?.weatherMain,
        rainProbPercent: weather?.rainProbPercent,
        savedAt: DateTime.now(),
      );

      final repo = ref.read(dailyRecordRepositoryProvider);
      await repo.save(record);
      state = record;
      return true;
    } catch (_) {
      return false;
    }
  }

  List<DailyRecord> loadAllRecords() {
    final repo = ref.read(dailyRecordRepositoryProvider);
    return repo.loadAll();
  }
}

final dailyRecordProvider =
    NotifierProvider<DailyRecordNotifier, DailyRecord>(DailyRecordNotifier.new);
