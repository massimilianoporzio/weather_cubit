class ServerException implements Exception {
  final String msg;
  ServerException({
    required this.msg,
  });
}

class WeatherException implements Exception {
  String message;

  WeatherException([this.message = 'Something went wrong']) {
    message = message;
  }

  @override
  String toString() => message;
}

class GenericException implements Exception {
  final String message;
  GenericException({
    this.message = 'Generic Error',
  });
}

class GeolocatorException implements Exception {
  String message;
  GeolocatorException([
    this.message = 'Problems occured using Locator Services',
  ]);
}
