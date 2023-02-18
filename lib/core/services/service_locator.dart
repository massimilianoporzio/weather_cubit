import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:openweather_cubit/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:openweather_cubit/features/weather/domain/entities/weather.dart';
import '../../features/geolocation/data/datasources/local_datasource.dart';
import '../../features/geolocation/data/datasources/local_datasource_impl.dart';
import '../../features/geolocation/data/repositories/geolocation_repo_impl.dart';
import '../../features/geolocation/domain/repositories/geolocation_repository.dart';
import '../../features/geolocation/domain/usecases/handle_permissions.dart';
import '../../features/weather/data/datasources/remote_datasource.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/fetch_weather_from_city.dart';
import '../../features/weather/domain/usecases/fetch_weather_from_current_location.dart';
import '../../features/weather/presentation/cubit/weather_cubit.dart';

import '../../features/temp_settings/presentation/cubit/temp_settings_cubit.dart';
import '../../features/weather/data/datasources/remote_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //blocs / cubits
  sl.registerFactory<WeatherCubit>(() => WeatherCubit(
        fetchWeatherCurrentPosition: sl(),
        handlePermissions: sl(),
        fetchWeatherFromCity: sl(),
      ));

  sl.registerFactory<TempSettingsCubit>(() => TempSettingsCubit());

  sl.registerFactory<ThemeCubit>(() => ThemeCubit());

  //usecases
  sl.registerLazySingleton(
      () => FetchWeatherFromCurrentLocationUsecase(weatherRepository: sl()));
  sl.registerLazySingleton(
      () => HandlePermissionsUseCase(geoLocationRepository: sl()));
  sl.registerLazySingleton(
      () => FetchWeatherFromCityUsecase(weatherRepository: sl()));

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
