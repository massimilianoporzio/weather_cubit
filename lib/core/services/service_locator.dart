import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:openweather_cubit/features/geolocation/data/datasources/local_datasource.dart';
import 'package:openweather_cubit/features/geolocation/data/datasources/local_datasource_impl.dart';
import 'package:openweather_cubit/features/geolocation/data/repositories/geolocation_repo_impl.dart';
import 'package:openweather_cubit/features/geolocation/domain/repositories/geolocation_repository.dart';
import 'package:openweather_cubit/features/weather/data/datasources/remote_datasource.dart';
import 'package:openweather_cubit/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

import '../../features/weather/data/datasources/remote_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //repositories
  sl.registerLazySingleton<WeatherRepository>(() =>
      WeatherRepositoryImpl(remoteDataSource: sl(), localGeoLocationDS: sl()));

  sl.registerLazySingleton<GeoLocationRepository>(
      () => GeoLocationRepositoryImpl(localDataSource: sl()));

  //DataSource
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(httpClient: sl()));

  sl.registerLazySingleton<GeolocationLocalDataSource>(
      () => GeoLocationLocalDSImpl());

  //externals
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
