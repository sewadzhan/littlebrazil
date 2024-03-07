part of 'cashback_bloc.dart';

abstract class CashbackState extends Equatable {
  const CashbackState();

  @override
  List<Object> get props => [];
}

class CashbackInitial extends CashbackState {}

class CashbackLoading extends CashbackState {}

class CashbackLoaded extends CashbackState {
  final CashbackData cashbackData;

  const CashbackLoaded(this.cashbackData);

  @override
  List<Object> get props => [cashbackData];
}
