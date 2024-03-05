import 'package:equatable/equatable.dart';

class MapLatLng extends Equatable {
  final double latitude;
  final double longitude;

  const MapLatLng({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
