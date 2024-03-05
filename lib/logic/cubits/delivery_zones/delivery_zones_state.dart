part of 'delivery_zones_cubit.dart';

abstract class DeliveryZonesState extends Equatable {
  const DeliveryZonesState();

  @override
  List<Object?> get props => [];
}

class DeliveryZonesLoadingState extends DeliveryZonesState {}

class DeliveryZonesLoadedState extends DeliveryZonesState {
  final List<DeliveryZone> deliveryZones;

  const DeliveryZonesLoadedState({required this.deliveryZones});

  @override
  List<Object?> get props => [deliveryZones];
}

class DeliveryZonesErrorState extends DeliveryZonesState {}
