import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:oneday/core/config/hive_config.dart';
import 'package:oneday/data/models/daily_record.dart';
import 'package:oneday/data/repositories/daily_record_repository.dart';

void main() {
  late Directory tempDir;
  late DailyRecordRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DailyRecordAdapter());
    }
    await Hive.openBox<DailyRecord>(HiveConfig.dailyRecordsBox);
    repo = DailyRecordRepository();
  });

  tearDown(() async {
    await Hive.box<DailyRecord>(HiveConfig.dailyRecordsBox).clear();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('DailyRecordRepository - loadToday()', () {
    test('저장된 데이터 없을 때 null 반환', () {
      final result = repo.loadToday();
      expect(result, isNull);
    });

    test('오늘 기록 저장 후 loadToday()로 조회 일치', () async {
      final today = DateTime.now();
      final record = DailyRecord(
        id: '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
        sentence: '테스트 한 문장',
        createdAt: today,
      );
      await repo.save(record);

      final loaded = repo.loadToday();
      expect(loaded, isNotNull);
      expect(loaded!.sentence, '테스트 한 문장');
    });
  });

  group('DailyRecordRepository - save() / loadAll()', () {
    test('여러 기록 저장 후 loadAll() 개수 일치', () async {
      final now = DateTime.now();
      await repo.save(DailyRecord(
        id: '2026-02-20',
        sentence: '첫째 날',
        createdAt: now.subtract(const Duration(days: 2)),
      ));
      await repo.save(DailyRecord(
        id: '2026-02-21',
        sentence: '둘째 날',
        createdAt: now.subtract(const Duration(days: 1)),
      ));
      await repo.save(DailyRecord(
        id: '2026-02-22',
        sentence: '셋째 날',
        createdAt: now,
      ));

      final all = repo.loadAll();
      expect(all.length, 3);
    });

    test('loadAll()이 최신순 정렬 (가장 최근이 첫 번째)', () async {
      final now = DateTime.now();
      await repo.save(DailyRecord(
        id: '2026-02-20',
        sentence: '오래된 기록',
        createdAt: now.subtract(const Duration(days: 2)),
      ));
      await repo.save(DailyRecord(
        id: '2026-02-22',
        sentence: '최신 기록',
        createdAt: now,
      ));

      final all = repo.loadAll();
      expect(all.first.sentence, '최신 기록');
    });
  });

  group('DailyRecordRepository - delete()', () {
    test('삭제 후 loadAll()에서 제거됨', () async {
      final now = DateTime.now();
      await repo.save(DailyRecord(
        id: '2026-02-22',
        sentence: '삭제할 기록',
        createdAt: now,
      ));

      await repo.delete('2026-02-22');
      final all = repo.loadAll();
      expect(all, isEmpty);
    });
  });

  // TypeAdapter read() 커버리지: 저장 후 Hive 재시작 → 디스크에서 역직렬화
  group('DailyRecordAdapter - read() 디스크 영속성', () {
    test('저장 후 Hive 재시작 시 TypeAdapter.read() 호출', () async {
      final now = DateTime(2026, 2, 22, 10, 0);
      await repo.save(DailyRecord(
        id: '2026-02-22',
        sentence: '디스크 영속성 테스트',
        tempCurrent: 15.5,
        tempMax: 18.0,
        tempMin: 10.0,
        weatherMain: 'Clouds',
        rainProbPercent: 30,
        createdAt: now,
        savedAt: now,
      ));

      // Hive 닫기 (디스크 플러시)
      await Hive.close();

      // 동일 경로로 재시작 → TypeAdapter.read() 호출됨
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DailyRecordAdapter());
      }
      await Hive.openBox<DailyRecord>(HiveConfig.dailyRecordsBox);
      final repo2 = DailyRecordRepository();

      final loaded = repo2.loadAll();
      expect(loaded.length, 1);
      expect(loaded.first.sentence, '디스크 영속성 테스트');
      expect(loaded.first.tempCurrent, 15.5);
      expect(loaded.first.weatherMain, 'Clouds');
    });
  });

  group('DailyRecordAdapter - hashCode / ==', () {
    test('같은 typeId → hashCode 동일', () {
      final a1 = DailyRecordAdapter();
      final a2 = DailyRecordAdapter();
      expect(a1.hashCode, a2.hashCode);
    });

    test('같은 typeId → == true', () {
      final a1 = DailyRecordAdapter();
      final a2 = DailyRecordAdapter();
      expect(a1 == a2, isTrue);
    });

    test('자기 자신과 identical → == true', () {
      final adapter = DailyRecordAdapter();
      expect(adapter == adapter, isTrue);
    });

    test('다른 타입과 비교 → false', () {
      final adapter = DailyRecordAdapter();
      expect(adapter == 'not an adapter', isFalse);
    });
  });
}
