import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class GreetingPicker {
  static List<String>? _morningMessages;
  static List<String>? _lunchMessages;
  static List<String>? _eveningMessages;

  static Future<void> initialize() async {
    final morningJson = await rootBundle.loadString('assets/greetings/morning_greetings.json');
    final lunchJson = await rootBundle.loadString('assets/greetings/lunch_greetings.json');
    final eveningJson = await rootBundle.loadString('assets/greetings/evening_greetings.json');

    _morningMessages = (jsonDecode(morningJson)['messages'] as List).cast<String>();
    _lunchMessages = (jsonDecode(lunchJson)['messages'] as List).cast<String>();
    _eveningMessages = (jsonDecode(eveningJson)['messages'] as List).cast<String>();
  }

  static String _pick(List<String> messages) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final shuffled = List<String>.from(messages)..shuffle(Random(now.year));
    return shuffled[dayOfYear % shuffled.length];
  }

  static String morningGreeting() {
    if (_morningMessages == null || _morningMessages!.isEmpty) {
      return '좋은 아침이에요, 오늘도 활기차게 시작해요';
    }
    return _pick(_morningMessages!);
  }

  static String lunchGreeting() {
    if (_lunchMessages == null || _lunchMessages!.isEmpty) {
      return '오후도 힘내세요, 이제 절반을 지났어요';
    }
    return _pick(_lunchMessages!);
  }

  static String eveningGreeting() {
    if (_eveningMessages == null || _eveningMessages!.isEmpty) {
      return '오늘 하루도 정말 수고하셨어요';
    }
    return _pick(_eveningMessages!);
  }
}
