import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'daily_record.g.dart';

@HiveType(typeId: 0)
class DailyRecord extends HiveObject {
  @HiveField(0)
  final String id; // 'yyyy-MM-dd' - 오늘 기록 조회를 위한 자연 키

  @HiveField(1)
  String sentence; // 오늘의 한 문장

  @HiveField(2)
  double? tempCurrent;

  @HiveField(3)
  double? tempMax;

  @HiveField(4)
  double? tempMin;

  @HiveField(5)
  String? weatherMain;

  @HiveField(6)
  int? rainProbPercent;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  DateTime? savedAt;

  DailyRecord({
    required this.id,
    required this.sentence,
    this.tempCurrent,
    this.tempMax,
    this.tempMin,
    this.weatherMain,
    this.rainProbPercent,
    required this.createdAt,
    this.savedAt,
  });

  factory DailyRecord.empty(DateTime date) => DailyRecord(
        id: DateFormat('yyyy-MM-dd').format(date),
        sentence: '',
        createdAt: date,
      );

  DailyRecord copyWith({
    String? sentence,
    double? tempCurrent,
    double? tempMax,
    double? tempMin,
    String? weatherMain,
    int? rainProbPercent,
    DateTime? savedAt,
  }) {
    return DailyRecord(
      id: id,
      sentence: sentence ?? this.sentence,
      tempCurrent: tempCurrent ?? this.tempCurrent,
      tempMax: tempMax ?? this.tempMax,
      tempMin: tempMin ?? this.tempMin,
      weatherMain: weatherMain ?? this.weatherMain,
      rainProbPercent: rainProbPercent ?? this.rainProbPercent,
      createdAt: createdAt,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
