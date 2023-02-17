import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/core/presentation/widgets/error_dialog.dart';
import 'package:openweather_cubit/core/utils/constants.dart';

import 'package:openweather_cubit/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:openweather_cubit/features/weather/presentation/pages/search_page.dart';
import 'package:openweather_cubit/features/weather/presentation/pages/settings_page.dart';
import 'package:openweather_cubit/features/weather/presentation/widgets/select_city_or_get_location.dart';
import 'package:recase/recase.dart';

import '../../../temp_settings/presentation/cubit/temp_settings_cubit.dart';

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
                builder: (_) => const SearchPage(),
              ));
              // print('city: $_city');
              if (_city != null) {
                if (mounted) {
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              }
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return '${((temperature * 9 / 5) + 32).toStringAsFixed(2)}℉';
    }
    return '${temperature.toStringAsFixed(2)}℃';
  }

  Widget formatDescription(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24),
    );
  }

  Widget showIcon(String icon) {
    final loadingWidget =
        Image.asset('assets/images/loading.gif', fit: BoxFit.cover);

    return CachedNetworkImage(
      width: 96,
      height: 96,
      imageUrl: 'https://${AppConstants.kIconHost}/img/wn/$icon@4x.png',
      placeholder: (context, url) => loadingWidget,
      errorWidget: (context, url, error) => const Icon(Icons.error),
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
          return ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              Text(
                state.weather.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TimeOfDay.fromDateTime(state.weather.lastUpdated.toLocal())
                        .format(context),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(${state.weather.country})',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showTemperature(state.weather.temp),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        showTemperature(state.weather.tempMax),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        showTemperature(state.weather.tempMin),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Spacer(),
                  showIcon(state.weather.icon),
                  Expanded(
                    flex: 3,
                    child: formatDescription(state.weather.description),
                  ),
                  const Spacer()
                ],
              ),
            ],
          );
        } else if (state.status == WeatherStatus.error &&
            state.weather.name == '') {
          return const SelectCityOrGetLocationWidget();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
