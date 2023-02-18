import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather_cubit/features/theme/presentation/cubit/theme_cubit.dart';

import 'core/services/service_locator.dart';
import 'core/services/service_locator.dart' as di;
import 'features/temp_settings/presentation/cubit/temp_settings_cubit.dart';
import 'features/weather/presentation/cubit/weather_cubit.dart';
import 'features/weather/presentation/pages/home_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(
          create: (context) => sl<WeatherCubit>(),
        ),
        BlocProvider<TempSettingsCubit>(
          create: (context) => sl<TempSettingsCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => sl<ThemeCubit>(),
        )
      ],
      child: BlocListener<WeatherCubit, WeatherState>(
        listener: (context, state) {
          context.read<ThemeCubit>().setTheme(state.weather.temp);
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: state.appTheme == AppTheme.light
                  ? ThemeData.light()
                  : ThemeData.dark(),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
