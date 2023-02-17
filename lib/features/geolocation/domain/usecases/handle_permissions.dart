import 'package:openweather_cubit/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:openweather_cubit/core/usecases/base_usecase.dart';
import 'package:openweather_cubit/features/geolocation/domain/repositories/geolocation_repository.dart';

class HandlePermissionsUseCase implements BaseUseCase {
  final GeoLocationRepository geoLocationRepository;

  HandlePermissionsUseCase({
    required this.geoLocationRepository,
  });

  @override
  Future<Either<Failure, dynamic>> call(parameters) async {
    return await geoLocationRepository.handleLocationPermission();
  }
}
