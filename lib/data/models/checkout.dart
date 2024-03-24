import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:littlebrazil/data/models/delivery_point.dart';

enum OrderType { delivery, pickup }

enum DeliveryTimeType { fast, certainTime, none }

enum PaymentMethod {
  applePay,
  googlePay,
  cash,
  nonCash,
  bankCard,
  savedBankCard,
  kaspi
}

//Model for Checkout page
class Checkout extends Equatable {
  final OrderType orderType;
  final Address address;
  final DeliveryTimeType deliveryTime;
  final int numberOfCutlery;
  final PaymentMethod paymentMethod;
  final DeliveryPoint? pickupPoint;
  final String certainTimeOrder;
  final String certainDayOrder;
  final int deliveryCost;
  final String organizationID;
  final String comments;
  // final Card? savedCard;

  const Checkout({
    required this.orderType,
    required this.address,
    required this.deliveryTime,
    required this.numberOfCutlery,
    required this.paymentMethod,
    required this.pickupPoint,
    required this.certainTimeOrder,
    required this.certainDayOrder,
    required this.deliveryCost,
    required this.organizationID,
    required this.comments,
    // required this.savedCard,
  });

  @override
  List<Object?> get props => [
        orderType,
        address,
        deliveryTime,
        numberOfCutlery,
        paymentMethod,
        pickupPoint,
        certainTimeOrder,
        certainDayOrder,
        deliveryCost,
        organizationID,
        comments
        // savedCard,
      ];

  Checkout copyWith({
    OrderType? orderType,
    Address? address,
    DeliveryTimeType? deliveryTime,
    int? numberOfCutlery,
    PaymentMethod? paymentMethod,
    DeliveryPoint? pickupPoint,
    String? certainTimeOrder,
    String? certainDayOrder,
    int? deliveryCost,
    String? organizationID,
    String? comments,
    // Card? savedCard,
  }) {
    return Checkout(
      orderType: orderType ?? this.orderType,
      address: address ?? this.address,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      numberOfCutlery: numberOfCutlery ?? this.numberOfCutlery,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      certainTimeOrder: certainTimeOrder ?? this.certainTimeOrder,
      certainDayOrder: certainDayOrder ?? this.certainDayOrder,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      organizationID: organizationID ?? this.organizationID,
      comments: comments ?? this.comments,
      // savedCard: savedCard ?? this.savedCard,
    );
  }
}
