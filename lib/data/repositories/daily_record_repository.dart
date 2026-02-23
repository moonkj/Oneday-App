import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:oneday/core/config/hive_config.dart';
import 'package:oneday/data/models/daily_record.dart';

class DailyRecordRepository {
  Box<DailyRecord> get _box => Hive.box<DailyRecord>(HiveConfig.dailyRecordsBox);

  /// 오늘의 기록 조회 (없으면 null)
  DailyRecord? loadToday() {
    final key = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _box.get(key);
  }

  /// 기록 저장 (키: 'yyyy-MM-dd')
  Future<void> save(DailyRecord record) async {
    await _box.put(record.id, record);
  }

  /// 전체 기록 조회 (최신순)
  List<DailyRecord> loadAll() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 특정 기록 삭제
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
