import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:openweather_cubit/core/usecases/base_usecase.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

class FetchWeatherFromCurrentLocationUsecase implements BaseUseCase {
  WeatherRepository weatherRepository;

  FetchWeatherFromCurrentLocationUsecase({
    required this.weatherRepository,
  });

  @override
  Future<Either<Failure, dynamic>> call(parameters) async {
    return await weatherRepository.fetchWeatherFroMCurrentLocation();
  }
}
