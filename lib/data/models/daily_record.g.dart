// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written TypeAdapter (hive_generator not used due to source_gen conflict)

part of 'daily_record.dart';

class DailyRecordAdapter extends TypeAdapter<DailyRecord> {
  @override
  final int typeId = 0;

  @override
  DailyRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyRecord(
      id: fields[0] as String,
      sentence: fields[1] as String,
      tempCurrent: fields[2] as double?,
      tempMax: fields[3] as double?,
      tempMin: fields[4] as double?,
      weatherMain: fields[5] as String?,
      rainProbPercent: fields[6] as int?,
      createdAt: fields[7] as DateTime,
      savedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sentence)
      ..writeByte(2)
      ..write(obj.tempCurrent)
      ..writeByte(3)
      ..write(obj.tempMax)
      ..writeByte(4)
      ..write(obj.tempMin)
      ..writeByte(5)
      ..write(obj.weatherMain)
      ..writeByte(6)
      ..write(obj.rainProbPercent)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
