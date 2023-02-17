import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/features/weather/presentation/cubit/weather_cubit.dart';

class SelectCityOrGetLocationWidget extends StatelessWidget {
  const SelectCityOrGetLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select a city\nor',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WeatherCubit>().fetchWeatherFromCurrentLocation();
            },
            child: const Text('get current location\'s weather'),
          ),
        ],
      ),
    );
  }
}
