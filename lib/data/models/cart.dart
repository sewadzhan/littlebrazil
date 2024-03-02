import 'package:equatable/equatable.dart';

import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/promocode.dart';

//Cart model
class Cart extends Equatable {
  final List<CartItemModel> items;
  final Promocode? activePromocode;

  const Cart(this.items, {this.activePromocode});

  int get subtotal => items.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.count);

  int get giftSubtotal => items.fold(0, (previousValue, element) {
        if (element.product.categoryTitle != 'Sets') {
          return previousValue + element.product.price * element.count;
        }
        return previousValue;
      });

  int get discount {
    if (activePromocode != null) {
      switch (activePromocode!.type) {
        case PromocodeType.percent:
          if (activePromocode!.iikoCategoryLimits.isEmpty) {
            return (subtotal / 100.0 * activePromocode!.value).toInt();
          }
          //Calculating subtotal without items with category limit
          int subtotalWithLimits = items.fold(0, (previousValue, element) {
            for (var categoryLimit in activePromocode!.iikoCategoryLimits) {
              if (categoryLimit == element.product.categoryID) {
                return previousValue;
              }
            }
            return previousValue + element.product.price * element.count;
          });
          return (subtotalWithLimits / 100.0 * activePromocode!.value).toInt();
        case PromocodeType.value:
          return activePromocode!.value.toInt();
      }
    }
    return 0;
  }

  @override
  List<Object?> get props => [items, activePromocode];

  Cart copyWith({
    List<CartItemModel>? items,
    Promocode? activePromocode,
  }) {
    return Cart(
      items ?? this.items,
      activePromocode: activePromocode ?? this.activePromocode,
    );
  }
}
