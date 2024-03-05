import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';

//Model for customer's addresses
class Address extends Equatable {
  final String id;
  final String address;
  final String apartmentOrOffice;
  final MapLatLng geopoint;

  const Address(
      {required this.id,
      required this.address,
      required this.apartmentOrOffice,
      required this.geopoint});

  @override
  List<Object?> get props => [address, apartmentOrOffice, geopoint];

  factory Address.fromMap(Map<String, dynamic> map) {
    GeoPoint pos = map['geopoint'];

    return Address(
        id: map['id'] ?? '',
        address: map['address'] ?? '',
        apartmentOrOffice: map['apartmentOrOffice'] ?? '',
        geopoint: MapLatLng(latitude: pos.latitude, longitude: pos.longitude));
  }

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'apartmentOrOffice': apartmentOrOffice,
      'geopoint': GeoPoint(geopoint.latitude, geopoint.longitude)
    };
  }
}
