import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    // 위치 서비스 활성화 확인
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionDeniedException('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException('위치 권한이 영구 거부되었습니다. 설정에서 허용해주세요.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // 도시 수준으로 충분
      timeLimit: const Duration(seconds: 15),
    );
  }
}

class LocationServiceDisabledException implements Exception {
  const LocationServiceDisabledException();
  @override
  String toString() => '위치 서비스가 비활성화되어 있습니다.';
}

class PermissionDeniedException implements Exception {
  final String message;
  const PermissionDeniedException(this.message);
  @override
  String toString() => message;
}
