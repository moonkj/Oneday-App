extension DoubleX on double {
  /// 온도를 정수형 문자열로 포매팅 (소수점 제거)
  String get tempString => '${toStringAsFixed(0)}°';

  /// 온도를 소수점 1자리로 포매팅
  String get tempStringDecimal => '${toStringAsFixed(1)}°';
}

extension NullableDoubleX on double? {
  String get tempString => this != null ? '${this!.toStringAsFixed(0)}°' : '--°';
}
