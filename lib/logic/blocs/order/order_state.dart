part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

//State for opening Paybox widget
class OrderPayboxInit extends OrderState {
  final Order order;

  const OrderPayboxInit(this.order);

  @override
  List<Object> get props => [order];
}

//Order was created successful state
class OrderSuccessful extends OrderState {
  final Order order;

  const OrderSuccessful(this.order);

  @override
  List<Object> get props => [order];
}

//During creating order
class OrderFailed extends OrderState {
  final String message;

  const OrderFailed(this.message);

  @override
  List<Object> get props => [message];
}
