import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:openweather_cubit/features/weather/domain/repositories/weather_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/service_locator.dart';
import '../../domain/entities/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _fetchWeather() async {
    final repository = sl<WeatherRepository>();

    dartz.Either<Failure, Weather> response =
        await repository.fetchWeather('london');

    response.fold((failure) => print(failure), (weather) => print(weather));
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
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
