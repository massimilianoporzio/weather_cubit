import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:openweather_cubit/features/weather/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() {
    context.read<WeatherCubit>().fetchWeatherFromCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              //*devo aspettare il risultato! per questo è async
              _city = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ));
              print('city: $_city');
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: const Center(child: Text('Home')),
    );
  }
}
