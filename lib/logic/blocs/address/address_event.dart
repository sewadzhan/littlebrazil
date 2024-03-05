part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddresses extends AddressEvent {
  final String phoneNumber;

  const LoadAddresses(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class AddressAdded extends AddressEvent {
  final AddAddressModel model;
  final String phoneNumber;
  final String apartment;

  const AddressAdded(
      {required this.phoneNumber,
      required this.model,
      required this.apartment});

  @override
  List<Object> get props => [model, apartment];
}

class AddressRemoved extends AddressEvent {
  final Address address;
  final String phoneNumber;

  const AddressRemoved({required this.phoneNumber, required this.address});

  @override
  List<Object> get props => [address];
}

//Set initial state (f.e. after log out)
class AddressSetToInitial extends AddressEvent {}
