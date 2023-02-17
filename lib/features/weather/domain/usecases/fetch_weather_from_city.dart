import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:openweather_cubit/core/usecases/base_usecase.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

class FetchWeatherFromCityUsecase extends BaseUseCase {
  final WeatherRepository weatherRepository;

  FetchWeatherFromCityUsecase({
    required this.weatherRepository,
  });

  @override
  Future<Either<Failure, dynamic>> call(parameters) async {
    return weatherRepository.fetchWeather(parameters.city);
  }
}

class CityParams extends Equatable {
  final String city;

  const CityParams({
    required this.city,
  });

  @override
  List<Object> get props => [city];
}
