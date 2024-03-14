part of 'order_history_bloc.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderHistory extends OrderHistoryEvent {
  final String phoneNumber;

  const LoadOrderHistory(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
