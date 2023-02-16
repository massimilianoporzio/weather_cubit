import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openweather_cubit/core/errors/exceptions.dart';

import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:openweather_cubit/features/geolocation/data/datasources/local_datasource.dart';
import 'package:openweather_cubit/features/geolocation/domain/repositories/geolocation_repository.dart';

class GeoLocationRepositoryImpl implements GeoLocationRepository {
  GeolocationLocalDataSource localDataSource;
  GeoLocationRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await localDataSource.isLocationServiceEnabled();
    } on GeolocatorException {
      return const Left(LocationServiceFailure(
          errMsg: 'Some problems occured with Location services'));
    } on Exception {
      return const Left(GenericFailure());
    }

    if (!serviceEnabled) {
      return const Left(LocationServiceFailure(
          errMsg:
              'Location services are disabled. Please enable the services'));
    }
    try {
      permission = await localDataSource.checkPermissions();
    } on GeolocatorException {
      return const Left(LocationServiceFailure(
          errMsg: 'Some problems occured with Location services'));
    } on Exception {
      return const Left(GenericFailure());
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Left(
            LocationServiceFailure(errMsg: 'Location permissions are denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return const Left(LocationServiceFailure(
          errMsg:
              'Location permissions are permanently denied, we cannot request permissions.'));
    }
    return const Right(true);
  }

  @override
  Future<Either<Failure, Position>> getCurrentPosition() async {
    try {
      final Position position = await localDataSource.getCurrentPosition();
      return Right(position);
    } catch (e) {
      return const Left(
          LocationServiceFailure(errMsg: 'Cannot retrieve current position'));
    }
  }
}
