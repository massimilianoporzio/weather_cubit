import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:openweather_cubit/features/weather/data/models/weather_model.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

_fetchWeatherFromCurrentLocation() async {
  WeatherRepository repo = sl();
  dartz.Either<Failure, Weather> response =
      await repo.fetchWeatherFroMCurrentLocation();
  response.fold(
    (failure) => print(failure),
    (weather) => print(weather),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherFromCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: const Center(child: Text('Home')),
    );
  }
}
