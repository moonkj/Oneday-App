import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

/// 날짜 시드 기반 저녁 위로 메시지 픽커
class EveningMessagePicker {
  static List<String>? _messages;

  static Future<void> initialize() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/evening/evening_messages.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      _messages = (data['messages'] as List).map((e) => e as String).toList();
    } catch (e) {
      _messages = [
        '오늘 하루도 정말 수고하셨어요. 편안한 밤 보내세요.',
        '오늘의 나는 최선을 다했어요. 그것으로 충분해요.',
        '잘 해낸 하루였어요. 이제 푹 쉬어도 돼요.',
      ];
    }
  }

  /// 연도+날짜 기반 결정적(deterministic) 메시지 반환 — 같은 해에 겹치지 않음
  static String todayMessage() {
    const fallback = '오늘 하루도 정말 수고하셨어요. 편안한 밤 보내세요.';
    if (_messages == null || _messages!.isEmpty) return fallback;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final shuffled = List<String>.from(_messages!)..shuffle(Random(now.year));
    return shuffled[dayOfYear % shuffled.length];
  }
}
