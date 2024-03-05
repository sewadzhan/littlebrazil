import 'dart:collection';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:littlebrazil/data/models/add_address.dart';
import 'package:littlebrazil/data/models/delivery_zone.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/view/config/map_tools.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

part 'add_address_event.dart';
part 'add_address_state.dart';

//Bloc for "Add Address" screen
class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final DeliveryZonesCubit deliveryZonesCubit;
  final YandexGeocoder geocoder =
      YandexGeocoder(apiKey: dotenv.env['YANDEX_GEOCODER']!);

  AddAddressBloc(this.deliveryZonesCubit)
      : super(const AddAddressLoaded(AddAddressModel(
            address: "",
            canBeDelivered: false,
            zoneDescription: "Поставьте маркер для добавления адреса"))) {
    on<NewAddressSetByMarker>(newAddressSetByMarkerToState);
    on<NewAddressSetBySuggest>(newAddressSetBySuggestToState);
  }

  //Set address by marker tapping on map
  newAddressSetByMarkerToState(
      NewAddressSetByMarker event, Emitter<AddAddressState> emit) async {
    var previousState = state;
    var currentState = state;
    try {
      if (currentState is AddAddressLoaded) {
        emit(AddAddressLoading());
        if (deliveryZonesCubit.state is DeliveryZonesLoadedState) {
          String address = await getAddress(event.geopoint);
          List<DeliveryZone> zones =
              (deliveryZonesCubit.state as DeliveryZonesLoadedState)
                  .deliveryZones;
          DeliveryZone? zone =
              MapTools.getIntersectedZone(zones, event.geopoint);
          Set<MapLatLng> markers = HashSet<MapLatLng>();
          markers.add(event.geopoint);
          if (zone != null) {
            emit(AddAddressLoaded(currentState.addAddressModel.copyWith(
                marker: markers,
                canBeDelivered: true,
                address: address,
                zoneDescription: zone.description)));
          } else {
            emit(AddAddressLoaded(currentState.addAddressModel.copyWith(
                marker: markers,
                canBeDelivered: false,
                address: address,
                zoneDescription:
                    "Доставка не осуществляется по этому адресу")));
          }
        }
      }
    } catch (e) {
      emit(const AddAddressFailed(
          "Произошла непредвиденная ошибка при определении адреса"));
      emit(previousState);
    }
  }

  //Set address by marker tapping on map
  newAddressSetBySuggestToState(
      NewAddressSetBySuggest event, Emitter<AddAddressState> emit) async {
    var previousState = state;
    var currentState = state;
    try {
      if (currentState is AddAddressLoaded) {
        emit(AddAddressLoading());
        if (deliveryZonesCubit.state is DeliveryZonesLoadedState) {
          GeocodeResponse geocodeResponse =
              await getGeocodePoint(event.address);

          if (geocodeResponse.firstPoint == null) {
            log("Address point was not found in Yandex");
            return;
          }
          MapLatLng geopoint = MapLatLng(
              latitude: geocodeResponse.firstPoint!.lat,
              longitude: geocodeResponse.firstPoint!.lon);
          List<DeliveryZone> zones =
              (deliveryZonesCubit.state as DeliveryZonesLoadedState)
                  .deliveryZones;
          DeliveryZone? zone = MapTools.getIntersectedZone(zones, geopoint);
          Set<MapLatLng> markers = HashSet<MapLatLng>();
          markers.add(geopoint);

          //Move map camera to marker
          emit(MapCameraMoved(geopoint));

          if (zone != null) {
            emit(AddAddressLoaded(currentState.addAddressModel.copyWith(
                marker: markers,
                canBeDelivered: true,
                address: event.address.replaceAll("Казахстан, Алматы, ", ""),
                zoneDescription: zone.description)));
          } else {
            emit(AddAddressLoaded(currentState.addAddressModel.copyWith(
                marker: markers,
                canBeDelivered: false,
                address: event.address.replaceAll("Казахстан, Алматы, ", ""),
                zoneDescription: "Поставьте маркер для добавления адреса")));
          }
        }
      }
    } catch (e) {
      emit(const AddAddressFailed(
          "Произошла непредвиденная ошибка при определении адреса"));
      emit(previousState);
    }
  }

  //Get accurate address using Yandex Geocoding package
  Future<String> getAddress(MapLatLng geopoint) async {
    final GeocodeResponse geocodeFromPoint =
        await geocoder.getGeocode(ReverseGeocodeRequest(
      pointGeocode: (lat: geopoint.latitude, lon: geopoint.longitude),
      lang: Lang.enEn,
    ));

    String address =
        geocodeFromPoint.firstFullAddress.formattedAddress.toString();

    return address.replaceAll("Казахстан, Алматы, ", "");
  }

  //Get accurate geocode point by address string using Yandex Geocoding package
  Future<GeocodeResponse> getGeocodePoint(String address) async {
    final GeocodeResponse geocodeFromAddress =
        await geocoder.getGeocode(DirectGeocodeRequest(
      addressGeocode: address,
      lang: Lang.enEn,
    ));

    return geocodeFromAddress;
  }
}
