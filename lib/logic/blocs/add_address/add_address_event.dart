part of 'add_address_bloc.dart';

abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object> get props => [];
}

class NewAddressSetByMarker extends AddAddressEvent {
  final MapLatLng geopoint;
  final String languageCode;

  const NewAddressSetByMarker(this.geopoint, this.languageCode);

  @override
  List<Object> get props => [geopoint, languageCode];
}

class NewAddressSetBySuggest extends AddAddressEvent {
  final String address;
  final String languageCode;

  const NewAddressSetBySuggest(this.address, this.languageCode);

  @override
  List<Object> get props => [address, languageCode];
}
