import 'package:openweather_cubit/features/weather/data/models/geocoding_model.dart';
import 'package:openweather_cubit/features/weather/data/models/weather_model.dart';
import 'package:openweather_cubit/features/weather/domain/entities/direct_geocoding.dart';

abstract class RemoteDataSource {
  Future<GeoCodingModel> getDirectGeocoding(String city);
  Future<WeatherModel> getWeather(DirectGeoCoding directGeoCoding);
}
