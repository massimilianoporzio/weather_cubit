import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPENWEATHER_KEY', obfuscate: true)
  static final WEATHER_API = _Env.WEATHER_API;
}
