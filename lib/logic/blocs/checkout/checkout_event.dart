part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

//Event for initialising LoadCheckout
class LoadCheckout extends CheckoutEvent {}

//Event for changing order type (delivery or local pickup)
class CheckoutOrderTypeChanged extends CheckoutEvent {
  final OrderType orderType;

  const CheckoutOrderTypeChanged(this.orderType);

  @override
  List<Object> get props => [orderType];
}

//Event for changing address
class CheckoutAddressChanged extends CheckoutEvent {
  final Address? address;

  const CheckoutAddressChanged(this.address);

  @override
  List<Object?> get props => [address];
}

//Event for changing delivery time
class CheckoutDeliveryTimeTypeChanged extends CheckoutEvent {
  final DeliveryTimeType deliveryTimeType;

  const CheckoutDeliveryTimeTypeChanged(this.deliveryTimeType);

  @override
  List<Object> get props => [deliveryTimeType];
}

//Event for increasing number of cutlery
class CheckoutNumberOfCutleryIncreased extends CheckoutEvent {
  const CheckoutNumberOfCutleryIncreased();

  @override
  List<Object> get props => [];
}

//Event for decreasing number of cutlery
class CheckoutNumberOfCutleryDecreased extends CheckoutEvent {
  const CheckoutNumberOfCutleryDecreased();

  @override
  List<Object> get props => [];
}

//Event for changing payment method
class CheckoutPaymentMethodChanged extends CheckoutEvent {
  final PaymentMethod paymentMethod;

  const CheckoutPaymentMethodChanged(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

//Event for changing pickup point address
class CheckoutPickupPointChanged extends CheckoutEvent {
  final DeliveryPoint pickupPoint;

  const CheckoutPickupPointChanged(this.pickupPoint);

  @override
  List<Object> get props => [pickupPoint];
}

//Event for changing certain time order
class CheckoutCertainTimeOrderChanged extends CheckoutEvent {
  final String certainTimeOrder;
  final String certainDayOrder;

  const CheckoutCertainTimeOrderChanged(
      {required this.certainTimeOrder, required this.certainDayOrder});

  @override
  List<Object> get props => [certainTimeOrder, certainDayOrder];
}

//Event for changing custom comments
class CheckoutCommentsChanged extends CheckoutEvent {
  final String comments;

  const CheckoutCommentsChanged({required this.comments});

  @override
  List<Object> get props => [comments];
}

// //Event for changing saved card if payment method is Saved Card
// class CheckoutSavedCardOrderChanged extends CheckoutEvent {
//   final Card card;

//   const CheckoutSavedCardOrderChanged(this.card);

//   @override
//   List<Object> get props => [card];
// }
