part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<Order> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderHistoryErrorState extends OrderHistoryState {
  final String message;

  const OrderHistoryErrorState(this.message);

  @override
  List<Object> get props => [message];
}
