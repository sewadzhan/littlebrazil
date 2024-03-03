import 'dart:convert';

import 'package:littlebrazil/data/models/delivery_point.dart';

//Model for contacts information
class ContactsModel {
  final String instagramUrl;
  final List<String> phones;
  final String webSite;
  final String whatsappUrl;
  final String tiktokUrl;
  final String youtubeUrl;
  final String closeHour;
  final String openHour;
  final int minOrderSum;
  final String playMarketUrl;
  final String appStoreUrl;
  final Map<String, bool> paymentMethods;
  final String studioUrl;
  final List<DeliveryPoint> pickupPoints;

  ContactsModel({
    required this.instagramUrl,
    required this.phones,
    required this.webSite,
    required this.whatsappUrl,
    required this.tiktokUrl,
    required this.youtubeUrl,
    required this.closeHour,
    required this.openHour,
    required this.minOrderSum,
    required this.playMarketUrl,
    required this.appStoreUrl,
    required this.paymentMethods,
    required this.studioUrl,
    this.pickupPoints = const [],
  });

  factory ContactsModel.fromMap(Map<String, dynamic> data) {
    Map<String, Map<String, dynamic>> pointsMap =
        Map<String, Map<String, dynamic>>.from(data['points']);

    List<DeliveryPoint> points = pointsMap.values.map((point) {
      // GeoPoint pos = point['geopoint'];
      return DeliveryPoint(
          address: point['address'],
          // latLng: LatLng(pos.latitude, pos.longitude),
          organizationID: point['organizationID']);
    }).toList();

    return ContactsModel(
        instagramUrl: data["instagramUrl"],
        phones: List.from(data['phones']),
        webSite: data["webSite"],
        whatsappUrl: data["whatsappUrl"],
        tiktokUrl: data["tiktokUrl"],
        youtubeUrl: data["youtubeUrl"],
        closeHour: data["workingHours"]['close'],
        openHour: data["workingHours"]['open'],
        minOrderSum: data['minimumOrderSum'],
        playMarketUrl: data["playMarketUrl"],
        appStoreUrl: data["appStoreUrl"],
        paymentMethods: Map<String, bool>.from(data["paymentMethods"]),
        studioUrl: data['studioUrl'],
        pickupPoints: points);
  }

  factory ContactsModel.fromJson(String source) =>
      ContactsModel.fromMap(json.decode(source));
}
