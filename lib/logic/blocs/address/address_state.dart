part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccessfullAdded extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;

  const AddressLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class AddressErrorState extends AddressState {
  final String message;

  const AddressErrorState(this.message);

  @override
  List<Object> get props => [message];
}
