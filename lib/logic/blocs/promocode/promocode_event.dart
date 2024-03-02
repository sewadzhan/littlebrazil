part of 'promocode_bloc.dart';

abstract class PromocodeEvent extends Equatable {
  const PromocodeEvent();

  @override
  List<Object> get props => [];
}

class LoadPromocodes extends PromocodeEvent {}

class PromocodeSubmited extends PromocodeEvent {
  final String code;

  PromocodeSubmited(this.code);

  @override
  List<Object> get props => [code];
}
