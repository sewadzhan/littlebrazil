part of 'suggest_address_bloc.dart';

abstract class SuggestAddressEvent extends Equatable {
  const SuggestAddressEvent();

  @override
  List<Object> get props => [];
}

//Event for searching addresses in Suggest Address page
class SuggestAddress extends SuggestAddressEvent {
  final String query;

  const SuggestAddress(this.query);

  @override
  List<Object> get props => [query];
}
