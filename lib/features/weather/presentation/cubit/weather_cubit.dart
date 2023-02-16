import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:openweather_cubit/features/weather/domain/entities/weather.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeatherFromCurrentLocation() async {
    emit(state.copyWith(status: WeatherStatus.loading));
    Either<Failure, Weather> weatherResponse =
        await weatherRepository.fetchWeatherFroMCurrentLocation();
    weatherResponse.fold(
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

  Future<void> fetcgWeather(String city) async {
    Either<Failure, Weather> weatherResponse =
        await weatherRepository.fetchWeather(city);
    weatherResponse.fold((failure) {
      emit(state.copyWith(status: WeatherStatus.error, failure: failure));
      print('state: $state');
    }, (weather) {
      emit(state.copyWith(weather: weather, status: WeatherStatus.loaded));
      print('state: $state');
    });
  }
}
