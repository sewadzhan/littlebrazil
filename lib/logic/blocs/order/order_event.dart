part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

//Event for validating order and if it is allright, call SuccessfulOrderCreated
class NewOrderPlaced extends OrderEvent {
  final Checkout checkout;
  final String comments;
  final String change;

  const NewOrderPlaced(
      {required this.checkout, required this.comments, required this.change});

  @override
  List<Object> get props => [checkout, comments, change];
}

//Creating order finally
class SuccessfulOrderCreated extends OrderEvent {
  final Checkout checkout;
  final Order order;

  const SuccessfulOrderCreated({required this.checkout, required this.order});

  @override
  List<Object> get props => [checkout];
}

//Creating order finally
class OrderPaymentProcessed extends OrderEvent {
  final Checkout checkout;
  final Order order;

  const OrderPaymentProcessed({required this.checkout, required this.order});

  @override
  List<Object> get props => [checkout, order];
}

//Event for showing errors
class OrderErrorOccured extends OrderEvent {
  final String message;

  const OrderErrorOccured(this.message);

  @override
  List<Object> get props => [message];
}
