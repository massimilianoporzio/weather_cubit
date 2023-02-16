import 'package:geolocator/geolocator.dart';

abstract class GeolocationLocalDataSource {
  Future<Position> getCurrentPosition();

  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermissions();
}
