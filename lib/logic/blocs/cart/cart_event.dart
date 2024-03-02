part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

//Event for initialising cart
class LoadCart extends CartEvent {}

//Event for adding number of product
class CartItemAdded extends CartEvent {
  final CartItemModel cartItem;

  const CartItemAdded(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

//Event for decreasing number of product
class CartItemDecreased extends CartEvent {
  final CartItemModel cartItem;

  const CartItemDecreased(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

//Event for removing certain product
class CartItemRemoved extends CartEvent {
  final CartItemModel cartItem;

  const CartItemRemoved(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

//Event for clearing cart
class CartCleared extends CartEvent {}

//Event for clearing items of certain category
class CartGiftCategoryItemsCleared extends CartEvent {
  final String categoryID;

  const CartGiftCategoryItemsCleared(this.categoryID);

  @override
  List<Object> get props => [categoryID];
}

//Event for applying promocode
class CartPromocodeApplied extends CartEvent {
  final Promocode promocode;

  const CartPromocodeApplied(this.promocode);

  @override
  List<Object> get props => [promocode];
}
