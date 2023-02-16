import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/exceptions.dart';
import 'local_datasource.dart';

class GeoLocationLocalDSImpl implements GeolocationLocalDataSource {
  @override
  Future<LocationPermission> checkPermissions() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      throw GeolocatorException();
    }
  }

  @override
  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw GeolocatorException();
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw GeolocatorException();
    }
  }
}
