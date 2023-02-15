import 'package:openweather_cubit/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel(
      {required super.description,
      required super.icon,
      required super.temp,
      required super.tempMin,
      required super.tempMax,
      required super.name,
      required super.country,
      required super.lastUpdated});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'];
    final main = json['main'];
    return WeatherModel(
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '',
      temp: main['temp']?.toDouble() ?? 0.0,
      tempMin: main['temp_min']?.toDouble() ?? 0.0,
      tempMax: main['temp_max']?.toDouble() ?? 0.0,
      name: '', //*presi dai dati di geolocalizz
      country: '', //*preso dai dati di geocoding
      lastUpdated: DateTime.now(),
    );
  }
}
