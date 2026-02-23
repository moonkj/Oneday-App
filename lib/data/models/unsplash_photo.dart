class UnsplashPhoto {
  final String id;
  final String regularUrl;
  final String fullUrl;
  final String? altDescription;
  final String photographerName;

  const UnsplashPhoto({
    required this.id,
    required this.regularUrl,
    required this.fullUrl,
    this.altDescription,
    required this.photographerName,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    final urls = json['urls'] as Map<String, dynamic>;
    final user = json['user'] as Map<String, dynamic>;

    return UnsplashPhoto(
      id: json['id'] as String,
      regularUrl: urls['regular'] as String,
      fullUrl: urls['full'] as String,
      altDescription: json['alt_description'] as String?,
      photographerName: user['name'] as String,
    );
  }

  /// API 없을 때 사용하는 폴백 (Unsplash Source URL - 무제한 무료)
  factory UnsplashPhoto.fallback(String query) {
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://source.unsplash.com/random/1080x1920/?$encodedQuery';
    return UnsplashPhoto(
      id: 'fallback_$query',
      regularUrl: url,
      fullUrl: url,
      altDescription: query,
      photographerName: 'Unsplash',
    );
  }
}
