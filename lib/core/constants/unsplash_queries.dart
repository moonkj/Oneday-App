import 'package:oneday/data/models/time_mode.dart';

abstract class UnsplashQueries {
  static const morningQueries = [
    'sunrise morning golden hour',
    'morning fresh nature',
    'dawn sunrise landscape',
    'morning light forest',
  ];

  static const lunchQueries = [
    'blue sky daytime',
    'sunny afternoon',
    'bright sky nature',
    'summer blue sky',
  ];

  static const eveningQueries = [
    'night sky stars',
    'sunset twilight',
    'evening calm ocean',
    'moonlight night',
  ];

  static String queryForMode(TimeMode mode) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    switch (mode) {
      case TimeMode.morning:
        return morningQueries[dayOfYear % morningQueries.length];
      case TimeMode.lunch:
        return lunchQueries[dayOfYear % lunchQueries.length];
      case TimeMode.evening:
        return eveningQueries[dayOfYear % eveningQueries.length];
    }
  }
}
