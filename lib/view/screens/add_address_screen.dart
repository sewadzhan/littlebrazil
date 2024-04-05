import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';
import 'package:littlebrazil/logic/blocs/add_address/add_address_bloc.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/geolocation/geolocation_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var addressController = TextEditingController();
  final apartmentController = TextEditingController();
  final panelController = PanelController();
  late final YandexMapController mapController;

  @override
  void dispose() {
    addressController.dispose();
    apartmentController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  List<MapObject> mapObjects = [];
                  for (var e in state.deliveryZones) {
                    mapObjects.add(PolygonMapObject(
                      mapId: MapObjectId(e.description),
                      polygon: Polygon(
                          outerRing: LinearRing(
                              points: e.geopoints
                                  .map((e) => Point(
                                      latitude: e.latitude,
                                      longitude: e.longitude))
                                  .toList()),
                          innerRings: const []),
                      strokeColor: e.color,
                      strokeWidth: 1.5,
                      fillColor: e.color.withAlpha(20),
                    ) as MapObject);
                  }
                  return Stack(
                    children: [
                      BlocConsumer<AddAddressBloc, AddAddressState>(
                        listener: (context, state) async {
                          //Move map camera to marker
                          if (state is MapCameraMoved) {
                            await mapController.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: Point(
                                        latitude: state.geopoint.latitude,
                                        longitude: state.geopoint.longitude),
                                    zoom: 16.65)));
                          }
                        },
                        builder: (context, addAddressState) {
                          if (addAddressState is AddAddressLoaded) {
                            //Initialising markers for map
                            MapLatLng? markerPoint =
                                addAddressState.addAddressModel.marker;
                            if (markerPoint != null) {
                              mapObjects = mapObjects
                                  .where(
                                      (element) => element is PolygonMapObject)
                                  .toList();
                              mapObjects.add(PlacemarkMapObject(
                                mapId: MapObjectId(
                                    'MapObject ${markerPoint.latitude}'),
                                point: Point(
                                    latitude: markerPoint.latitude,
                                    longitude: markerPoint.longitude),
                                opacity: 1,
                                icon: PlacemarkIcon.single(
                                  PlacemarkIconStyle(
                                    image: BitmapDescriptor.fromAssetImage(
                                      'assets/icons/map-point.png',
                                    ),
                                    scale: 2,
                                  ),
                                ),
                              ) as MapObject);
                            }
                          }
                          return YandexMap(
                            mapObjects: mapObjects,
                            onMapCreated: (controller) async {
                              mapController = controller;

                              // await mapController.setMinZoom(zoom: 10);
                              // await mapController.setMaxZoom(zoom: 18.5);
                              // await mapController.setMapStyle(
                              //     "{'stylers': {'zoom': [10, 18.5],}}");

                              if (geolocationState is GeolocationLoaded) {
                                //Enabling location user layer
                                await mapController.toggleUserLayer(
                                    visible: true);
                              }
                            },
                            onUserLocationAdded: (view) async {
                              await mapController.moveCamera(
                                CameraUpdate.newCameraPosition(
                                    const CameraPosition(
                                        target: Point(
                                            latitude: 43.2398052,
                                            longitude: 76.8906515),
                                        zoom: 11.4)),
                                animation: const MapAnimation(
                                  type: MapAnimationType.linear,
                                  duration: 0.3,
                                ),
                              );
                              // Getting the user location
                              var userLocation =
                                  await mapController.getUserCameraPosition();
                              // Setting the initial camera if location is found
                              if (userLocation != null) {
                                // await mapController.moveCamera(
                                //   CameraUpdate.newCameraPosition(
                                //     userLocation.copyWith(zoom: 15),
                                //   ),
                                //   animation: const MapAnimation(
                                //     type: MapAnimationType.linear,
                                //     duration: 0.3,
                                //   ),
                                // );
                              }

                              // Changing the view of location marker
                              return view.copyWith(
                                pin: view.pin.copyWith(
                                  opacity: 1,
                                ),
                              );
                            },
                            onMapTap: (Point geopoint) {
                              context.read<AddAddressBloc>().add(
                                  NewAddressSetByMarker(MapLatLng(
                                      latitude: geopoint.latitude,
                                      longitude: geopoint.longitude)));
                              if (panelController.isPanelClosed) {
                                panelController.open();
                              }
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
                    addressController = TextEditingController(
                        text: state.addAddressModel.address);
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
                          addressController =
                              TextEditingController(text: address);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context
                                .read<AddAddressBloc>()
                                .add(NewAddressSetBySuggest(address));
                          });
                        }
                      },
                      onlyRead: true,
                      titleText: "Адрес",
                      hintText: hintText.isEmpty ? "Введите адрес" : hintText,
                      controller: addressController,
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
                          var phoneNumber =
                              context.read<AuthCubit>().state!.phoneNumber!;
                          context.read<AddressBloc>().add(AddressAdded(
                              phoneNumber: phoneNumber,
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
