import 'package:dartz/dartz.dart';
import 'package:openweather_cubit/features/weather/domain/entities/weather.dart';

import '../../../../core/errors/failures.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> fetchWeather(String city);
}
