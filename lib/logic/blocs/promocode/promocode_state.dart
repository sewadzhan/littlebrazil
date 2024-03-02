part of 'promocode_bloc.dart';

abstract class PromocodeState extends Equatable {
  const PromocodeState();

  @override
  List<Object> get props => [];
}

class PromocodeInitial extends PromocodeState {}

class PromocodeLoadSuccess extends PromocodeState {
  final List<Promocode> promocodes;

  PromocodeLoadSuccess(this.promocodes);

  @override
  List<Object> get props => [promocodes];
}

class PromocodeSubmitSuccess extends PromocodeState {}

class PromocodeSubmitLoading extends PromocodeState {}

class PromocodeFailure extends PromocodeState {
  final String message;

  PromocodeFailure(this.message);

  @override
  List<Object> get props => [message];
}
