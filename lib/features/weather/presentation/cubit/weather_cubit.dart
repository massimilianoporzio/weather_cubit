import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/base_usecase.dart';

import '../../../geolocation/domain/usecases/handle_permissions.dart';
import '../../domain/entities/weather.dart';

import '../../domain/usecases/fetch_weather_from_city.dart';
import '../../domain/usecases/fetch_weather_from_current_location.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final FetchWeatherFromCurrentLocationUsecase fetchWeatherCurrentPosition;
  final HandlePermissionsUseCase handlePermissions;
  final FetchWeatherFromCityUsecase fetchWeatherFromCity;

  WeatherCubit({
    required this.fetchWeatherCurrentPosition,
    required this.handlePermissions,
    required this.fetchWeatherFromCity,
  }) : super(WeatherState.initial());

  Future<void> fetchWeatherFromCurrentLocation() async {
    emit(state.copyWith(
      status: WeatherStatus.loading,
    ));
    final result = await handlePermissions(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
          message: failure.errMsg,
          weather: Weather.initial(),
          status: WeatherStatus.error)),
      (permissionOk) {
        if (!permissionOk) {
          emit(state.copyWith(
              message: 'Permissions denied for Location Services',
              status: WeatherStatus.error));
        }
        //non fa nulla se invece è ok nel senso che va avanti
      },
    );
    final weatherResult =
        await fetchWeatherCurrentPosition(const NoParameters());
    weatherResult.fold(
      (failure) {
        emit(state.copyWith(
            weather: Weather.initial(),
            message: failure.errMsg,
            status: WeatherStatus.error));
        print('state: $state');
      },
      (weather) {
        emit(state.copyWith(
            status: WeatherStatus.loaded, weather: weather, message: ''));
        print('state: $state');
      },
    );
  }

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(
        status: WeatherStatus.loading, weather: Weather.initial()));
    final result = await fetchWeatherFromCity(CityParams(city: city));
    result.fold((failure) {
      emit(
          state.copyWith(status: WeatherStatus.error, message: failure.errMsg));
      print('state: $state');
    }, (weather) {
      emit(state.copyWith(
          weather: weather, status: WeatherStatus.loaded, message: ''));
      print('state: $state');
    });
  }
}
