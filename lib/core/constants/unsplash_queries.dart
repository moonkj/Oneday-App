import 'package:oneday/data/models/time_mode.dart';

abstract class UnsplashQueries {
  // 아침: 따뜻하고 부드러운 빛, 일상의 시작 무드
  static const morningQueries = [
    'morning light bokeh minimal',
    'cozy morning window mist',
    'golden hour soft bokeh',
    'morning coffee aesthetic calm',
    'dawn fog serene minimal',
    'soft sunrise pastel sky',
  ];

  // 점심: 밝고 청량한 하늘, 깔끔한 구도
  static const lunchQueries = [
    'clear blue sky minimal',
    'afternoon sunlight bokeh',
    'bright white architecture light',
    'daytime clouds minimal aesthetic',
    'summer light nature calm',
    'blue sky clean minimal',
  ];

  // 저녁: 무드있는 어둠, 보케, 도시 감성
  static const eveningQueries = [
    'cozy evening bokeh warm',
    'night rain window bokeh',
    'blue hour city minimal',
    'evening lamp light moody',
    'dark aesthetic moody calm',
    'twilight purple sky blur',
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

  // 시간대별 색조 힌트 (Unsplash color 파라미터)
  static String? colorForMode(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return 'orange'; // 따뜻한 앰버/황금빛
      case TimeMode.lunch:
        return 'blue';   // 청량한 하늘빛
      case TimeMode.evening:
        return 'black';  // 어둡고 무드있는
    }
  }
}
