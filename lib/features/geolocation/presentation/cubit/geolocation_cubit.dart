import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'geolocation_state.dart';

class GeolocationCubit extends Cubit<GeolocationState> {
  GeolocationCubit() : super(GeolocationInitial());
}
