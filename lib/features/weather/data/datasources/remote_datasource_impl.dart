import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openweather_cubit/core/errors/exceptions.dart';
import 'package:openweather_cubit/features/weather/domain/entities/direct_geocoding.dart';
import 'package:openweather_cubit/features/weather/data/models/weather_model.dart';

import '../../../../core/utils/constants.dart';
import '../../../../envied/env.dart';
import '../models/geocoding_model.dart';
import 'remote_datasource.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client httpClient;

  RemoteDataSourceImpl({
    required this.httpClient,
  });

  String httpErrorHandler(http.Response response) {
    final statusCode = response.statusCode;
    final reasonPhrase = response.reasonPhrase;
    final errorMessage =
        'Request failed\nStatus Code: $statusCode\nReason: $reasonPhrase';
    return errorMessage;
  }

  @override
  Future<GeoCodingModel> getDirectGeocoding(String city) async {
    //fornisco la query
    final geocodingUri = Uri(
        scheme: 'https',
        host: AppConstants.kApiHost,
        path: '/geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': AppConstants.kLimit,
          'appid': Env.WEATHER_API
        });

    try {
      final http.Response response = await httpClient.get(geocodingUri);
      if (response.statusCode != 200) {
        throw ServerException(msg: httpErrorHandler(response));
      }
      List responseList = json.decode(response.body);
      if (responseList.isNotEmpty) {
        final Map<String, dynamic> responseBody = responseList[0];

        if (responseBody.isEmpty) {
          throw WeatherException('Cannot get the location of $city');
        }
        final geoCodingModel = GeoCodingModel.fromJson(responseBody);
        return geoCodingModel;
      } else {
        throw WeatherException('Cannot get the location of $city');
      }
    } on ServerException catch (se) {
      print(se);
      rethrow;
    } on WeatherException catch (we) {
      print(we);
      rethrow;
    } on Exception catch (e) {
      throw GenericException();
    }
  }

  @override
  Future<WeatherModel> getWeather(DirectGeoCoding directGeoCoding) async {
    final weatherUri = Uri(
        scheme: 'https',
        host: AppConstants.kApiHost,
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': '${directGeoCoding.lat}',
          'lon': '${directGeoCoding.lon}',
          'limit': AppConstants.kLimit,
          'appid': Env.WEATHER_API,
          'units': AppConstants.kUnit
        });

    try {
      final http.Response response = await httpClient.get(weatherUri);
      if (response.statusCode != 200) {
        throw ServerException(msg: httpErrorHandler(response));
      }
      final weatherJson = json.decode(response.body);
      final weather = WeatherModel.fromJson(weatherJson);
      return weather;
    } on ServerException {
      rethrow;
    } on WeatherException {
      rethrow;
    } on Exception catch (e) {
      throw GenericException();
    }
  }

  @override
  Future<String> getCityFromCoordinates(double lat, double lon) async {
    final geocodingUri = Uri(
        scheme: 'https',
        host: AppConstants.kApiHost,
        path: '/geo/1.0/reverse',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lon',
          'limit': AppConstants.kLimit,
          'appid': Env.WEATHER_API
        });

    try {
      final http.Response response = await httpClient.get(geocodingUri);
      if (response.statusCode != 200) {
        throw ServerException(msg: httpErrorHandler(response));
      }
      final Map<String, dynamic> responseBody = json.decode(response.body)[0];
      final String city = responseBody['name'];
      return city;
    } on ServerException {
      rethrow;
    } on Exception {
      throw GenericException();
    }
  }

  @override
  Future<WeatherModel> getWeatherFromCoordinates(double lat, double lon) async {
    final weatherUri = Uri(
        scheme: 'https',
        host: AppConstants.kApiHost,
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lon',
          'limit': AppConstants.kLimit,
          'appid': Env.WEATHER_API,
          'units': AppConstants.kUnit
        });

    try {
      final http.Response response = await httpClient.get(weatherUri);
      if (response.statusCode != 200) {
        throw ServerException(msg: httpErrorHandler(response));
      }
      final weatherJson = json.decode(response.body);
      final weather = WeatherModel.fromJson(weatherJson);
      return weather;
    } on ServerException {
      rethrow;
    } on WeatherException {
      rethrow;
    } on Exception catch (e) {
      throw GenericException();
    }
  }
}
