//Model for delivery points of restaurant
class DeliveryPoint {
  final String address;
  //final LatLng latLng;
  final String organizationID;

  DeliveryPoint({required this.address, required this.organizationID});

  @override
  String toString() {
    return "Point address: $address\norganizationID: $organizationID";
  }
}
