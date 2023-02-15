import 'package:openweather_cubit/features/weather/domain/entities/direct_geocoding.dart';

class GeoCodingModel extends DirectGeoCoding {
  const GeoCodingModel(
      {required super.name,
      required super.country,
      required super.lat,
      required super.lon});

  factory GeoCodingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json[0]; //primo e unico elemento della lista che torna da API
    return GeoCodingModel(
      name: data["name"],
      lat: data["lat"]?.toDouble(),
      lon: data["lon"]?.toDouble(),
      country: data["country"],
    );
  }
}
