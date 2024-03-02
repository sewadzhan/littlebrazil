import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:littlebrazil/data/models/base_product.dart';
import 'package:littlebrazil/data/models/order_modifier.dart';

//Model for cart item
class CartItemModel extends Equatable {
  final BaseProduct product;
  final int count;
  final List<OrderModifier> orderModifiers;

  const CartItemModel(
      {required this.product,
      required this.count,
      this.orderModifiers = const []});

  CartItemModel copyWith(
      {BaseProduct? product, int? count, List<OrderModifier>? orderModifiers}) {
    return CartItemModel(
        product: product ?? this.product,
        count: count ?? this.count,
        orderModifiers: orderModifiers ?? this.orderModifiers);
  }

  @override
  List<Object?> get props => [product, count, orderModifiers];

  @override
  String toString() {
    return "Product title: ${product.title}, count: $count, orderModifiers: $orderModifiers";
  }

  Map<String, dynamic> toMap() {
    return {
      'productTitle': product.title,
      'productPrice': product.price,
      'count': count,
      'orderModifiers': orderModifiers.map((e) => e.toFirebaseMap())
    };
  }

  String toJson() => json.encode(toMap());
}
