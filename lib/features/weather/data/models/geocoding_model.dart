import 'package:openweather_cubit/features/weather/domain/entities/direct_geocoding.dart';

class GeoCodingModel extends DirectGeoCoding {
  const GeoCodingModel(
      {required super.name,
      required super.country,
      required super.lat,
      required super.lon});

  factory GeoCodingModel.fromJson(Map<String, dynamic> json) {
    return GeoCodingModel(
      name: json["name"] ?? '',
      lat: json["lat"]?.toDouble(),
      lon: json["lon"]?.toDouble(),
      country: json["country"] ?? '',
    );
  }
}
