import 'package:intl/intl.dart';
import 'package:oneday/core/constants/unsplash_queries.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/data/models/unsplash_photo.dart';
import 'package:oneday/data/services/unsplash_service.dart';

class ImageRepository {
  final UnsplashService _service;
  final Map<String, UnsplashPhoto> _cache = {};

  ImageRepository(this._service);

  /// 시간대별 랜덤 이미지 조회 (같은 날 같은 모드는 캐시 반환)
  Future<UnsplashPhoto> fetchForMode(TimeMode mode) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final cacheKey = '${mode.name}_$dateStr';

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final query = UnsplashQueries.queryForMode(mode);
    final photo = await _service.fetchRandomPhoto(query: query);
    _cache[cacheKey] = photo;
    return photo;
  }

  /// 캐시를 무시하고 새 이미지 강제 로드
  Future<UnsplashPhoto> refreshForMode(TimeMode mode) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final cacheKey = '${mode.name}_$dateStr';
    _cache.remove(cacheKey);
    return fetchForMode(mode);
  }
}
