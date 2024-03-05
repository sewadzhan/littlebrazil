import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

//Bloc for geolocation in Google maps
class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  StreamSubscription? _geolocationSubscription;

  GeolocationBloc() : super(GeolocationLoading()) {
    on<LoadGeolocation>(mapLoadGeolocationToState);
    on<UpdateGeolocation>(mapUpdateGeolocationToState);
  }

  mapLoadGeolocationToState(
      LoadGeolocation event, Emitter<GeolocationState> emit) async {
    try {
      _geolocationSubscription?.cancel();

      emit(GeolocationLoading());

      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      //Check geolocation permissions
      if (permission != LocationPermission.always) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          emit(GeolocationError());
          return;
        }
      }

      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      add(UpdateGeolocation(position: position));
    } catch (e) {
      emit(GeolocationError());
    }
  }

  mapUpdateGeolocationToState(
      UpdateGeolocation event, Emitter<GeolocationState> emit) async {
    emit(GeolocationLoaded(position: event.position));
  }

  @override
  Future<void> close() {
    _geolocationSubscription?.cancel();
    return super.close();
  }
}
