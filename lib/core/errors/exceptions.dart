class ServerException implements Exception {
  final String msg;
  ServerException({
    required this.msg,
  });
}

class WeatherException implements Exception {
  String message;

  WeatherException([this.message = 'Something went wrong']) {
    message = 'Weather Exception: $message';
  }

  @override
  String toString() => message;
}

class GenericException implements Exception {}
