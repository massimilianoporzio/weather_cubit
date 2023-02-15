import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errMsg;

  const Failure({required this.errMsg});

  @override
  List<Object> get props => [errMsg];

  @override
  String toString() => 'Failure(errMsg: $errMsg)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errMsg});

  @override
  String toString() {
    return 'ServerFailure(errMsg: $errMsg)';
  }
}

class WeatherFailure extends Failure {
  const WeatherFailure({required super.errMsg});

  @override
  String toString() {
    return 'WeatherFailure(errMsg: $errMsg)';
  }
}

class GenericFailure extends Failure {
  const GenericFailure({super.errMsg = "Generic Error"});
}
