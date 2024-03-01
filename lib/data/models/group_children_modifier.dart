//Class for group children modifier of product in Iiko Menu
import 'package:equatable/equatable.dart';

class GroupChildrenModifier extends Equatable {
  final String name;
  final int price;
  final String id;
  final int minAmount;
  final int maxAmount;
  final int defaultAmount;

  const GroupChildrenModifier(
      {required this.name,
      required this.price,
      required this.id,
      this.minAmount = 0,
      this.maxAmount = 0,
      this.defaultAmount = 0});

  factory GroupChildrenModifier.fromMapIiko(
      Map<String, dynamic> modifier, Map<String, dynamic> group) {
    double price = List.from(modifier['sizePrices']).isNotEmpty
        ? modifier['sizePrices'][0]['price']['currentPrice']
        : 0;

    return GroupChildrenModifier(
        name: modifier['name'], price: price.toInt(), id: modifier['id']);
  }

  GroupChildrenModifier copyWith(
      {String? name,
      int? price,
      String? id,
      int? minAmount,
      int? maxAmount,
      int? defaultAmount}) {
    return GroupChildrenModifier(
        name: name ?? this.name,
        price: price ?? this.price,
        id: id ?? this.id,
        minAmount: minAmount ?? this.minAmount,
        maxAmount: maxAmount ?? this.maxAmount);
  }

  @override
  String toString() {
    return "id: $id, name: $name, price: $price, minAmount: $minAmount, maxAmount: $maxAmount, defaultAmount: $defaultAmount";
  }

  @override
  List<Object?> get props =>
      [id, name, minAmount, maxAmount, defaultAmount, price];
}
