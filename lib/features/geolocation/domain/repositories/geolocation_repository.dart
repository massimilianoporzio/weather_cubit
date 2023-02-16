import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openweather_cubit/core/errors/failures.dart';

abstract class GeoLocationRepository {
  Future<Either<Failure, bool>> handleLocationPermission();
  Future<Either<Failure, Position>> getCurrentPosition();
}
