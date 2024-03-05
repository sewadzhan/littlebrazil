part of 'add_address_bloc.dart';

abstract class AddAddressState extends Equatable {
  const AddAddressState();

  @override
  List<Object> get props => [];
}

class AddAddressInitial extends AddAddressState {}

class AddAddressLoading extends AddAddressState {}

class AddAddressLoaded extends AddAddressState {
  final AddAddressModel addAddressModel;

  const AddAddressLoaded(this.addAddressModel);

  @override
  List<Object> get props => [addAddressModel];
}

class MapCameraMoved extends AddAddressState {
  final MapLatLng geopoint;

  const MapCameraMoved(this.geopoint);

  @override
  List<Object> get props => [geopoint];
}

//Failed results
class AddAddressFailed extends AddAddressState {
  final String message;

  const AddAddressFailed(this.message);

  @override
  List<Object> get props => [message];
}
