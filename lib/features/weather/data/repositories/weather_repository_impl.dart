import 'package:geolocator/geolocator.dart';
import 'package:openweather_cubit/core/errors/exceptions.dart';
import 'package:openweather_cubit/features/geolocation/data/datasources/local_datasource.dart';
import 'package:openweather_cubit/features/weather/domain/entities/direct_geocoding.dart';
import 'package:openweather_cubit/features/weather/domain/entities/weather.dart';
import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

import '../datasources/remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteDataSource remoteDataSource;
  final GeolocationLocalDataSource localGeoLocationDS;
  WeatherRepositoryImpl({
    required this.localGeoLocationDS,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Weather>> fetchWeather(String city) async {
    try {
      DirectGeoCoding directGeocoding =
          await remoteDataSource.getDirectGeocoding(city);
      Weather tempWeather = await remoteDataSource.getWeather(directGeocoding);
      //potrebbe avere i nomi sballati li cambio
      print('tempWeather: $tempWeather');
      final weather = tempWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);

      return Right(weather);
    } on ServerException catch (se) {
      return Left(ServerFailure(errMsg: se.msg));
    } on WeatherException catch (we) {
      return Left(WeatherFailure(errMsg: we.message));
    } on Exception {
      return const Left(GenericFailure());
    }
  }

  @override
  Future<Either<Failure, Weather>> fetchWeatherFroMCurrentLocation() async {
    try {
      await localGeoLocationDS.checkPermissions();
      final serivecesEnabled =
          await localGeoLocationDS.isLocationServiceEnabled();
      if (!serivecesEnabled) {
        return const Left(
            LocationServiceFailure(errMsg: 'Location Services are disabled'));
      }
      final Position currentPosition =
          await localGeoLocationDS.getCurrentPosition();
      final city = await remoteDataSource.getCityFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      DirectGeoCoding directGeocoding =
          await remoteDataSource.getDirectGeocoding(city);
      Weather tempWeather = await remoteDataSource.getWeather(directGeocoding);
      final weather = tempWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);

      return Right(weather);
    } on GeolocatorException catch (ge) {
      return Left(LocationServiceFailure(errMsg: ge.message));
    } on Exception {
      return const Left(GenericFailure());
    }
  }
}
