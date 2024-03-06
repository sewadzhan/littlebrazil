import 'package:equatable/equatable.dart';

import 'package:littlebrazil/data/models/maplatlng.dart';

//Model for "Add address screen" to keep data for further saving client address
class AddAddressModel extends Equatable {
  final String address;
  final bool canBeDelivered;
  final String zoneDescription;
  final MapLatLng? marker;

  const AddAddressModel(
      {required this.address,
      required this.canBeDelivered,
      required this.zoneDescription,
      this.marker});

  AddAddressModel copyWith(
      {String? address,
      bool? canBeDelivered,
      String? zoneDescription,
      MapLatLng? marker}) {
    return AddAddressModel(
        address: address ?? this.address,
        canBeDelivered: canBeDelivered ?? this.canBeDelivered,
        zoneDescription: zoneDescription ?? this.zoneDescription,
        marker: marker);
  }

  @override
  List<Object?> get props => [address, canBeDelivered, zoneDescription, marker];
}
