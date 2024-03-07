part of 'cashback_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

//Load cashback data from Firestore
class LoadCashbackData extends AddressEvent {}

//Deposit cashback to user account
class CashbackDeposited extends AddressEvent {
  final int value;
  final String phoneNumber;

  const CashbackDeposited({required this.value, required this.phoneNumber});

  @override
  List<Object> get props => [value, phoneNumber];
}

//Withdraw cashback from user account
class CashbackWithdrawed extends AddressEvent {
  final int value;
  final String phoneNumber;

  const CashbackWithdrawed({required this.value, required this.phoneNumber});

  @override
  List<Object> get props => [value, phoneNumber];
}

//Change cashback action for further actions after successfull payment
class CashbackActionChanged extends AddressEvent {
  final CashbackAction cashbackAction;

  const CashbackActionChanged({required this.cashbackAction});

  @override
  List<Object> get props => [cashbackAction];
}
