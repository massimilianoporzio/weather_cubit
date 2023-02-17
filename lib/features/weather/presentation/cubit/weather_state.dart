part of 'weather_cubit.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error;
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final String message;

  const WeatherState({
    required this.status,
    required this.weather,
    this.message = '',
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
    );
  }

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, message: $message)';

  @override
  List<Object> get props => [status, weather, message];

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    String? message,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      message: message ?? this.message,
    );
  }
}
