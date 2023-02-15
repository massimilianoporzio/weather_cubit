import 'package:equatable/equatable.dart';

class DirectGeoCoding extends Equatable {
  final String name;

  final String country;
  final double lat;
  final double lon;

  const DirectGeoCoding({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object> get props {
    return [
      name,
      country,
      lat,
      lon,
    ];
  }

  @override
  String toString() {
    return 'DirectGeoCoding(name: $name, country: $country, lat: $lat, lon: $lon)';
  }

  DirectGeoCoding copyWith({
    String? name,
    String? country,
    double? lat,
    double? lon,
  }) {
    return DirectGeoCoding(
      name: name ?? this.name,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
