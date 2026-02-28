import 'package:dio/dio.dart';
import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/data/models/unsplash_photo.dart';

class UnsplashService {
  final Dio _dio;

  UnsplashService(this._dio);

  /// Unsplash 랜덤 사진 조회
  Future<UnsplashPhoto> fetchRandomPhoto({
    required String query,
    String? color,
  }) async {
    try {
      final params = <String, dynamic>{
        'query': query,
        'orientation': 'portrait',
        'content_filter': 'high',
      };
      if (color != null) params['color'] = color;

      final response = await _dio.get(
        '${AppConfig.unsplashBaseUrl}/photos/random',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Client-ID ${AppConfig.unsplashAccessKey}',
            'Accept-Version': 'v1',
          },
        ),
      );
      return UnsplashPhoto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // API 실패 시 Unsplash Source URL로 폴백
      return UnsplashPhoto.fallback(query);
    }
  }
}
