part of 'add_address_bloc.dart';

abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object> get props => [];
}

class NewAddressSetByMarker extends AddAddressEvent {
  final MapLatLng geopoint;

  const NewAddressSetByMarker(this.geopoint);

  @override
  List<Object> get props => [geopoint];
}

class NewAddressSetBySuggest extends AddAddressEvent {
  final String address;

  const NewAddressSetBySuggest(this.address);

  @override
  List<Object> get props => [address];
}
