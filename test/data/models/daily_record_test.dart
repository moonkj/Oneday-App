import 'package:flutter_test/flutter_test.dart';
import 'package:oneday/data/models/daily_record.dart';

void main() {
  group('DailyRecord.empty()', () {
    test('id가 yyyy-MM-dd 형식', () {
      final date = DateTime(2026, 2, 22);
      final record = DailyRecord.empty(date);
      expect(record.id, '2026-02-22');
    });

    test('sentence가 빈 문자열', () {
      final record = DailyRecord.empty(DateTime.now());
      expect(record.sentence, '');
    });

    test('선택 필드는 null', () {
      final record = DailyRecord.empty(DateTime.now());
      expect(record.tempCurrent, isNull);
      expect(record.weatherMain, isNull);
      expect(record.savedAt, isNull);
    });
  });

  group('DailyRecord.copyWith()', () {
    test('sentence 변경 시 id 유지', () {
      final base = DailyRecord.empty(DateTime(2026, 2, 22));
      final updated = base.copyWith(sentence: '오늘 하루 수고했어요');

      expect(updated.id, '2026-02-22');
      expect(updated.sentence, '오늘 하루 수고했어요');
    });

    test('날씨 필드 업데이트', () {
      final base = DailyRecord.empty(DateTime.now());
      final updated = base.copyWith(
        tempCurrent: 15.5,
        weatherMain: 'Clouds',
        rainProbPercent: 20,
      );

      expect(updated.tempCurrent, 15.5);
      expect(updated.weatherMain, 'Clouds');
      expect(updated.rainProbPercent, 20);
      expect(updated.sentence, ''); // 나머지 유지
    });
  });
}
