part of 'suggest_address_bloc.dart';

abstract class SuggestAddressState extends Equatable {
  const SuggestAddressState();

  @override
  List<Object> get props => [];
}

//Initial state of suggest address page
class SuggestAddressInitial extends SuggestAddressState {}

//Loading state for suggest address page
class SuggestAddressLoading extends SuggestAddressState {}

//Success results of suggest address of products
class SuggestAddressSuccess extends SuggestAddressState {
  final List<String> addresses;

  const SuggestAddressSuccess(this.addresses);

  @override
  List<Object> get props => [addresses];
}

//Failed results of product suggest address
class SuggestAddressFailed extends SuggestAddressState {
  final String message;

  const SuggestAddressFailed(this.message);

  @override
  List<Object> get props => [message];
}
