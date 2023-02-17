import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
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
    emit(state.copyWith(status: WeatherStatus.loading));
    final result = await handlePermissions(const NoParameters());
    result.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: WeatherStatus.error)),
      (permissionOk) {
        if (!permissionOk) {
          emit(state.copyWith(
              failure: const LocationServiceFailure(
                  errMsg: 'Permissions denied for Location Services'),
              status: WeatherStatus.error));
        }
        //non fa nulla se invece è ok nel senso che va avanti
      },
    );
    final weatherResult =
        await fetchWeatherCurrentPosition(const NoParameters());
    weatherResult.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: WeatherStatus.error));
        print('state: $state');
      },
      (weather) {
        emit(state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ));
        print('state: $state');
      },
    );
  }

  Future<void> fetchWeather(String city) async {
    final result = await fetchWeatherFromCity(CityParams(city: city));
    result.fold((failure) {
      emit(state.copyWith(status: WeatherStatus.error, failure: failure));
      print('state: $state');
    }, (weather) {
      emit(state.copyWith(weather: weather, status: WeatherStatus.loaded));
      print('state: $state');
    });
  }
}
