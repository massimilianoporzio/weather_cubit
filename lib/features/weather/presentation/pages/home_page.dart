import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/core/presentation/widgets/error_dialog.dart';
import 'package:openweather_cubit/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:openweather_cubit/features/weather/presentation/pages/search_page.dart';
import 'package:openweather_cubit/features/weather/presentation/widgets/select_city_or_get_location.dart';

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
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, errorMsg: state.message);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const SelectCityOrGetLocationWidget();
        } else if (state.status == WeatherStatus.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'fetching Weather data...',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          );
        } else if (state.status == WeatherStatus.loaded) {
          return Center(
            child: Text(
              state.weather.name,
              style: const TextStyle(fontSize: 18),
            ),
          );
        } else if (state.status == WeatherStatus.error &&
            state.weather.name == '') {
          return const SelectCityOrGetLocationWidget();
        } else {
          return SizedBox();
        }
      },
    );
  }
}
