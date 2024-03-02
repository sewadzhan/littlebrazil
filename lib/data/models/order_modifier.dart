//Class for modifier for delivery order IIKO

import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/group_children_modifier.dart';

class OrderModifier extends Equatable {
  final int amount;
  final String productGroupId;
  final String productGroupName;
  final GroupChildrenModifier modifier;

  const OrderModifier({
    required this.modifier,
    required this.amount,
    required this.productGroupId,
    required this.productGroupName,
  });

  OrderModifier copyWith(
      {int? amount,
      GroupChildrenModifier? modifier,
      String? productGroupId,
      String? productGroupName}) {
    return OrderModifier(
        productGroupId: productGroupId ?? this.productGroupId,
        productGroupName: productGroupName ?? this.productGroupName,
        modifier: modifier ?? this.modifier,
        amount: amount ?? this.amount);
  }

  @override
  String toString() {
    return "modifier: $modifier, amount: $amount";
  }

  //For IIKO CLOUD API
  Map<String, dynamic> toMap() {
    return {
      "productId": modifier.id,
      "amount": amount,
      "productGroupId": productGroupId,
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      "productId": modifier.id,
      "amount": amount,
      "name": modifier.name,
      "productGroupId": productGroupId,
      "productGroupName": productGroupName,
    };
  }

  //For order history page
  factory OrderModifier.fromMap(Map<String, dynamic> map) {
    return OrderModifier(
        modifier: GroupChildrenModifier(
            name: map['name'], id: map['productId'], price: 0),
        amount: 1,
        productGroupId: "",
        productGroupName: map['productGroupName']);
  }

  @override
  List<Object?> get props =>
      [amount, modifier, productGroupId, productGroupName];
}
