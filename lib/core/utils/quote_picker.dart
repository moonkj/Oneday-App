import 'dart:convert';
import 'package:flutter/services.dart';

class Quote {
  final String text;
  final String author;
  const Quote({required this.text, required this.author});
}

/// 날짜 시드 기반 유명인 명언 픽커
class QuotePicker {
  static List<Quote>? _quotes;

  static Future<void> initialize() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/quotes/quotes_ko.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      _quotes = (data['quotes'] as List).map((e) {
        final m = e as Map<String, dynamic>;
        return Quote(text: m['text'] as String, author: m['author'] as String);
      }).toList();
    } catch (e) {
      _quotes = [
        const Quote(text: '인생은 자전거를 타는 것과 같다. 균형을 잡으려면 계속 움직여야 한다.', author: '알베르트 아인슈타인'),
        const Quote(text: '당신이 할 수 있다고 생각하든, 할 수 없다고 생각하든, 당신이 옳다.', author: '헨리 포드'),
        const Quote(text: '꿈을 꿀 수 있다면 그것을 이룰 수도 있다.', author: '월트 디즈니'),
      ];
    }
  }

  /// 연도+날짜 기반 결정적(deterministic) 명언 반환 — iOS 위젯과 동일 공식 사용
  static Quote todayQuote() {
    const fallback = Quote(
      text: '오늘 하루도 충분히 잘 해내고 있습니다.',
      author: 'ONE DAY',
    );
    if (_quotes == null || _quotes!.isEmpty) return fallback;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    // (year * 1000 + dayOfYear) % count — Swift 위젯과 동일한 공식
    final index = (now.year * 1000 + dayOfYear) % _quotes!.length;
    return _quotes![index];
  }
}
