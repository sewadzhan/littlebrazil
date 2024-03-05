import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';
import 'package:littlebrazil/logic/blocs/add_address/add_address_bloc.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/geolocation/geolocation_bloc.dart';
// import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var addressController = TextEditingController();
    var apartmentController = TextEditingController();
    var panelController = PanelController();
    GoogleMapController? mapController;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.darkGrayColor,
        elevation: 0,
        leading: TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: SizedBox(
            width: 25,
            child: SvgPicture.asset('assets/icons/arrow-left.svg',
                colorFilter: const ColorFilter.mode(
                    Constants.darkGrayColor, BlendMode.srcIn)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        maxHeight: 420,
        minHeight: 100,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        body: BlocBuilder<GeolocationBloc, GeolocationState>(
          builder: (context, geolocationState) {
            return BlocBuilder<DeliveryZonesCubit, DeliveryZonesState>(
              builder: (context, state) {
                if (state is DeliveryZonesLoadedState &&
                    geolocationState is! GeolocationLoading) {
                  return Stack(
                    children: [
                      BlocConsumer<AddAddressBloc, AddAddressState>(
                        listener: (context, state) {
                          //Move map camera to marker
                          if (state is MapCameraMoved) {
                            mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(state.geopoint.latitude,
                                        state.geopoint.longitude),
                                    zoom: 17.5)));
                          }
                        },
                        builder: (context, addAddressState) {
                          Set<Marker> markerSet = HashSet<Marker>();
                          var cameraPosition = const CameraPosition(
                              target: LatLng(43.2398052, 76.8906515),
                              zoom: 11.5);
                          //Init initial camera position depending on geolocation
                          var geolocationState =
                              context.read<GeolocationBloc>().state;
                          if (geolocationState is GeolocationLoaded) {
                            cameraPosition = CameraPosition(
                                target: LatLng(
                                    geolocationState.position.latitude,
                                    geolocationState.position.longitude),
                                zoom: 17.5);
                          }
                          if (addAddressState is AddAddressLoaded) {
                            //Initialising markers for map
                            if (addAddressState.addAddressModel.marker !=
                                null) {
                              markerSet = addAddressState
                                  .addAddressModel.marker!
                                  .map((e) => Marker(
                                      markerId: MarkerId("${e.latitude}"),
                                      position: LatLng(e.latitude, e.longitude),
                                      draggable: true,
                                      onDragEnd: (LatLng geopoint) {
                                        context.read<AddAddressBloc>().add(
                                            NewAddressSetByMarker(MapLatLng(
                                                latitude: geopoint.latitude,
                                                longitude:
                                                    geopoint.longitude)));
                                        if (panelController.isPanelClosed) {
                                          panelController.open();
                                        }
                                      }))
                                  .toSet();
                            }
                          }

                          return GoogleMap(
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            myLocationEnabled: true,
                            markers: markerSet,
                            polygons: state.deliveryZones.map((e) {
                              return Polygon(
                                  polygonId: PolygonId(e.description),
                                  points: e.geopoints
                                      .map((e) =>
                                          LatLng(e.latitude, e.longitude))
                                      .toList(),
                                  strokeWidth: 1,
                                  fillColor: e.color.withAlpha(20),
                                  strokeColor: e.color);
                            }).toSet(),
                            initialCameraPosition: cameraPosition,
                            onTap: (LatLng geopoint) {
                              context.read<AddAddressBloc>().add(
                                  NewAddressSetByMarker(MapLatLng(
                                      latitude: geopoint.latitude,
                                      longitude: geopoint.longitude)));
                              if (panelController.isPanelClosed) {
                                panelController.open();
                              }
                            },
                            onMapCreated: (controller) {
                              mapController = controller;
                            },
                          );
                        },
                      )
                    ],
                  );
                }
                return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Constants.primaryColor,
                                strokeWidth: 2.5,
                              )),
                        ],
                      ),
                    ));
              },
            );
          },
        ),
        panel: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
              vertical: Constants.defaultPadding * 0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.75),
                child: Center(
                  child: Container(
                    width: 35,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Constants.lightGrayColor,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                child: Text("Укажите адрес доставки",
                    style: Constants.headlineTextTheme.displayMedium!.copyWith(
                      color: Constants.primaryColor,
                    )),
              ),
              BlocBuilder<AddAddressBloc, AddAddressState>(
                builder: (context, state) {
                  String hintText = "";

                  if (state is AddAddressLoaded) {
                    hintText = state.addAddressModel.address;
                  } else if (state is AddAddressLoading) {
                    hintText = "Определение адреса...";
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding * 0.75),
                    child: CustomTextInputField(
                      onTap: () async {
                        //Get suggested address from Yandex Suggest
                        dynamic addressDynamic = await Navigator.pushNamed(
                            context, '/suggestAddress');
                        String address = addressDynamic;
                        if (address.isNotEmpty) {
                          context
                              .read<AddAddressBloc>()
                              .add(NewAddressSetBySuggest(address));
                        }
                      },
                      titleText: "Адрес",
                      hintText: hintText,
                      controller: addressController,
                      onlyRead: true,
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: CustomTextInputField(
                    titleText: "Квартира/офис",
                    hintText: "Введите номер квартиры или офиса",
                    controller: apartmentController),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Row(
                  children: [
                    SizedBox(
                        width: 25,
                        height: 25,
                        child: SvgPicture.asset('assets/icons/bus.svg',
                            colorFilter: const ColorFilter.mode(
                                Constants.darkGrayColor, BlendMode.srcIn))),
                    SizedBox(width: Constants.defaultPadding * 0.75),
                    BlocBuilder<AddAddressBloc, AddAddressState>(
                      builder: (context, state) {
                        return Text(
                            state is AddAddressLoaded
                                ? state.addAddressModel.zoneDescription
                                : "Определение адреса...",
                            style: Constants.textTheme.bodyMedium);
                      },
                    )
                  ],
                ),
              ),
              BlocConsumer<AddressBloc, AddressState>(
                listener: (context, state) {
                  if (state is AddressSuccessfullAdded) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return CustomElevatedButton(
                      isLoading: state is AddressLoading,
                      isEnabled: state is AddressLoaded,
                      text: "СОХРАНИТЬ АДРЕС",
                      function: () async {
                        var addAddressState =
                            context.read<AddAddressBloc>().state;
                        if (addAddressState is AddAddressLoaded) {
                          // var phoneNumber =
                          //     context.read<AuthCubit>().state!.phoneNumber!;
                          context.read<AddressBloc>().add(AddressAdded(
                              phoneNumber: "+77086053541",
                              model: addAddressState.addAddressModel,
                              apartment: apartmentController.text));
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
