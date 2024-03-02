import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cart.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/promocode.dart';

part 'cart_event.dart';
part 'cart_state.dart';

//Bloc for cart functionality
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCart>(loadCartToState);
    on<CartItemAdded>(cartItemAddedToState);
    on<CartItemDecreased>(cartItemDecreasedToState);
    on<CartItemRemoved>(cartItemRemovedToState);
    on<CartCleared>(cartClearedToState);
    on<CartGiftCategoryItemsCleared>(cartGiftCategoryItemsClearedToState);
    on<CartPromocodeApplied>(cartPromocodeAppliedToState);
  }

  static Function eq = const ListEquality().equals;

  loadCartToState(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    emit(const CartLoaded(Cart(<CartItemModel>[])));
  }

  //Adding cart item
  cartItemAddedToState(CartItemAdded event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      //Small vibration for feedback
      HapticFeedback.mediumImpact();

      int cartItemIndex = (state as CartLoaded).cart.items.indexWhere(
            (item) =>
                item.product.rmsID == event.cartItem.product.rmsID &&
                eq(item.orderModifiers, event.cartItem.orderModifiers),
          );

      if (cartItemIndex >= 0) {
        _changeCartItemCount(
            cartItemIndex, event.cartItem.count, state as CartLoaded, emit);
      } else {
        emit(CartLoaded((state as CartLoaded).cart.copyWith(
            items: List.from((state as CartLoaded).cart.items)
              ..add(event.cartItem))));
      }
    }
  }

  cartItemDecreasedToState(CartItemDecreased event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      int cartItemIndex = (state as CartLoaded).cart.items.indexWhere(
            (item) =>
                item.product.rmsID == event.cartItem.product.rmsID &&
                eq(item.orderModifiers, event.cartItem.orderModifiers),
          );

      if (cartItemIndex >= 0) {
        if ((state as CartLoaded).cart.items[cartItemIndex].count == 1) {
          emit(CartLoaded((state as CartLoaded).cart.copyWith(
              items: List.from((state as CartLoaded).cart.items)
                ..remove(event.cartItem))));
        } else {
          _changeCartItemCount(cartItemIndex, -1, (state as CartLoaded), emit);
        }
      }
    }
  }

  //Removing cart item from cart
  cartItemRemovedToState(CartItemRemoved event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      //Small vibration for feedback
      HapticFeedback.mediumImpact();

      int cartItemIndex = (state as CartLoaded).cart.items.indexWhere(
            (item) =>
                item.product.rmsID == event.cartItem.product.rmsID &&
                eq(item.orderModifiers, event.cartItem.orderModifiers),
          );

      if (cartItemIndex >= 0) {
        emit(CartLoaded((state as CartLoaded).cart.copyWith(
            items: List.from((state as CartLoaded).cart.items)
              ..removeAt(cartItemIndex))));
      }
    }
  }

  cartClearedToState(CartCleared event, Emitter<CartState> emit) {
    emit(const CartLoaded(Cart(<CartItemModel>[])));
  }

  _changeCartItemCount(
      int index, int value, CartLoaded state, Emitter<CartState> emit) {
    //Small vibration for feedback
    HapticFeedback.lightImpact();

    List<CartItemModel> items = List.from(state.cart.items);
    int itemCount = state.cart.items[index].count;
    if (itemCount + value < 100) {
      items[index] = state.cart.items[index].copyWith(count: itemCount + value);
      emit(CartLoaded(state.cart.copyWith(items: items)));
    }
  }

  //Clearing cart
  cartGiftCategoryItemsClearedToState(
      CartGiftCategoryItemsCleared event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      List<CartItemModel> items = (state as CartLoaded)
          .cart
          .items
          .where((element) => element.product.categoryID != event.categoryID)
          .toList();
      emit(CartLoaded((state as CartLoaded).cart.copyWith(items: items)));
    }
  }

  //Promocode applying
  cartPromocodeAppliedToState(
      CartPromocodeApplied event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      emit(CartLoaded((state as CartLoaded)
          .cart
          .copyWith(activePromocode: event.promocode)));
    }
  }
}
