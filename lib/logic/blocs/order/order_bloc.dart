import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/data/models/cashback_data.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';

part 'order_event.dart';
part 'order_state.dart';

//Bloc for creating order
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirestoreRepository firestoreRepository;
  //final IikoRepository iikoRepository;
  final CartBloc cartBloc;
  final ContactsCubit contactsCubit;
  final CurrentUserBloc currentUserBloc;
  final CashbackBloc cashbackBloc;
  final BottomSheetCubit bottomSheetCubit;
  OrderBloc(
      {required this.cartBloc,
      required this.contactsCubit,
      required this.currentUserBloc,
      required this.firestoreRepository,
      required this.cashbackBloc,
      required this.bottomSheetCubit})
      : super(OrderInitial()) {
    on<NewOrderPlaced>(newOrderPlacedToState);
    on<OrderPaymentProcessed>(orderPaymentProcessedToState);
    on<SuccessfulOrderCreated>(successfulOrderCreatedToState);
    on<OrderErrorOccured>(((event, emit) => emit(OrderFailed(event.message))));
  }

  //New order placed
  newOrderPlacedToState(NewOrderPlaced event, Emitter<OrderState> emit) async {
    if (cartBloc.state is CartLoaded &&
        currentUserBloc.state is CurrentUserRetrieveSuccessful) {
      emit(OrderLoading());
      try {
        validateCheckout(event.checkout);

        var cartBlocState = cartBloc.state as CartLoaded;

        String fullAddress = event.checkout.orderType == OrderType.delivery
            ? "${event.checkout.address.address}, кв/оф ${event.checkout.address.apartmentOrOffice}"
            : event.checkout.pickupPoint!.address;
        Order order = Order(
          phoneNumber: (currentUserBloc.state as CurrentUserRetrieveSuccessful)
              .user
              .phoneNumber,
          fullAddress: fullAddress,
          deliveryCost: event.checkout.deliveryCost,
          discount: cartBlocState.cart.discount,
          subtotal: cartBlocState.cart.subtotal,
          total: cartBlocState.cart.subtotal -
              cartBlocState.cart.discount +
              event.checkout.deliveryCost,
          paymentMethod: event.checkout.paymentMethod,
          orderType: event.checkout.orderType,
          cartItems: cartBlocState.cart.items,
          id: generateOrderID(),
          dateTime: DateTime.now(),
          cashbackUsed: 0,
          comments: event.checkout.comments,
          // changeWith: event.change.isNotEmpty ? int.parse(event.change) : null,
        );

        // if (event.checkout.paymentMethod == PaymentMethod.bankCard) {
        //   //Show the pay instruction bottom sheet
        //   bottomSheetCubit.showPayInstructionBottomSheet();
        // }
        add(OrderPaymentProcessed(checkout: event.checkout, order: order));
      } on SocketException {
        emit(const OrderFailed("Возникли проблемы с интернет соединением"));
        return;
      } on RestaurantException catch (e) {
        emit(OrderFailed(e.toString()));
        return;
      }
    }
  }

  //Process payment
  orderPaymentProcessedToState(
      OrderPaymentProcessed event, Emitter<OrderState> emit) async {
    CurrentUserState currentUserState = currentUserBloc.state;
    Order order = event.order;

    if (currentUserState is CurrentUserRetrieveSuccessful) {
      try {
        emit(OrderLoading());

        var cashbackAction =
            (cashbackBloc.state as CashbackLoaded).cashbackData.cashbackAction;

        //Change discount value if cashback action is Withdraw
        if (cashbackAction == CashbackAction.withdraw) {
          //Withdraw all cashback of current user
          var newDiscountValue =
              currentUserState.user.cashback + event.order.discount;
          var newTotal = event.order.total - currentUserState.user.cashback;
          order = event.order.copyWith(
              discount: newDiscountValue, total: newTotal < 0 ? 0 : newTotal);
        }

        //Payment process
        if (order.paymentMethod == PaymentMethod.bankCard) {
          emit(OrderPayboxInit(order));
        } else if (order.paymentMethod == PaymentMethod.kaspi) {}
      } on SocketException {
        emit(const OrderFailed("Возникли проблемы с интернет соединением"));
        return;
      } on PlatformException {
        emit(const OrderFailed("Не удалось произвести оплату"));
        emit(OrderInitial());
        return;
      } on RestaurantException catch (e) {
        emit(OrderFailed(e.toString()));
        return;
      } catch (e) {
        emit(OrderFailed("UNKNOWN ERROR $e"));
        return;
      }
    }
  }

  successfulOrderCreatedToState(
      SuccessfulOrderCreated event, Emitter<OrderState> emit) async {
    // var currentUserState = currentUserBloc.state;
    // var cartBlocState = cartBloc.state;
    // var order = event.order;
    // if (cartBlocState is CartLoaded &&
    //     currentUserState is CurrentUserRetrieveSuccessful) {
    //   try {
    //     emit(OrderLoading());

    //     //Deposit or withdraw cashback
    //     var cashbackState = cashbackBloc.state;
    //     if (cashbackState is CashbackLoaded) {
    //       if (cashbackState.cashbackData.cashbackAction ==
    //           CashbackAction.deposit) {
    //         //Calculate deposit depending on subtotal and cashback percent
    //         //and check the individual cashback percent
    //         int newCashback = 0;
    //         if (currentUserState.user.individualCashbackPercent == null) {
    //           newCashback = ((cartBlocState.cart.subtotal / 100.0) *
    //                   cashbackState.cashbackData.percent)
    //               .toInt();
    //         } else {
    //           newCashback = ((cartBlocState.cart.subtotal / 100.0) *
    //                   currentUserState.user.individualCashbackPercent!)
    //               .toInt();
    //         }

    //         cashbackBloc.add(CashbackDeposited(
    //             value: newCashback,
    //             phoneNumber: currentUserState.user.phoneNumber));
    //         order = order.copyWith(cashbackUsed: newCashback);
    //       } else if (cashbackState.cashbackData.cashbackAction ==
    //           CashbackAction.withdraw) {
    //         var withdrawValue = currentUserState.user.cashback;
    //         //Withdraw all cashback of current user
    //         cashbackBloc.add(CashbackWithdrawed(
    //             value: currentUserState.user.cashback,
    //             phoneNumber: currentUserState.user.phoneNumber));

    //         order = order.copyWith(cashbackUsed: withdrawValue * -1);
    //       }
    //     }

    //     //Sending order to telegram chat for orders
    //     var botTOken = dotenv.env['TELEGRAM_ORDER_BOT_TOKEN'].toString();
    //     var chatID = dotenv.env['TELEGRAM_ORDER_CHAT_ID'].toString();
    //     final username = (await Telegram(botTOken).getMe()).username;
    //     var teledart = TeleDart(botTOken, Event(username!));

    //     await teledart.sendMessage(
    //         chatID, Config.getOrderInfoForTelegram(order, event.checkout));

    //     var token = await iikoRepository.getToken();
    //     await iikoRepository.createDelivery(
    //         token: token,
    //         organizationID: event.checkout.organizationID,
    //         checkout: event.checkout,
    //         user: (currentUserBloc.state as CurrentUserRetrieveSuccessful).user,
    //         cart: (cartBloc.state as CartLoaded).cart,
    //         comments: event.order.comments,
    //         changeWith: event.order.changeWith,
    //         cashbackUsed: order.cashbackUsed,
    //         numberOfPersons: event.checkout.numberOfPersons);

    //     // //Sending email about successful order
    //     await firestoreRepository.sendEmail(
    //         "help@pikapika.kz",
    //         "Новый заказ с приложения №${order.id}",
    //         Config.getEmailTemplateHTML(order, event.checkout));

    //     // Write order in Firebase Firestore
    //     await firestoreRepository.createOrder(order);

    //     //Add the used promocode to certain user's collection if it can be used only once
    //     var activePromocode = cartBlocState.cart.activePromocode;
    //     if (activePromocode != null && activePromocode.canBeUsedOnlyOnce) {
    //       await firestoreRepository.addUsedPromocodeToUser(
    //           currentUserState.user.phoneNumber, activePromocode.code);
    //       //Update current user state
    //       currentUserBloc.add(CurrentUserSet(currentUserState.user.copyWith(
    //           usedPromocodes: List.from(currentUserState.user.usedPromocodes)
    //             ..add(activePromocode.code))));
    //     }

    //     emit(OrderSuccessful(order));
    //     cartBloc.add(CartCleared());
    //   } on SocketException {
    //     emit(const OrderFailed("Возникли проблемы с интернет соединением"));
    //     return;
    //   } on RestaurantException catch (e) {
    //     emit(OrderFailed(e.toString()));
    //     return;
    //   } catch (e) {
    //     emit(OrderFailed(e.toString()));
    //     return;
    //   }
    // }
  }

  //Validate checkout fields
  void validateCheckout(Checkout checkout) {
    if (cartBloc.state is! CartLoaded ||
        contactsCubit.state is! ContactsLoadedState) {
      throw RestaurantException("Произошла непредвиденная ошибка");
    }
    var minSumOrder =
        (contactsCubit.state as ContactsLoadedState).contactsModel.minOrderSum;

    //Check minimum sum order when order type is delivery
    if (checkout.orderType == OrderType.delivery &&
        (cartBloc.state as CartLoaded).cart.subtotal < minSumOrder) {
      throw RestaurantException(
          "Минимальная сумма заказа составляет $minSumOrder тенге");
    }
    if (checkout.orderType == OrderType.delivery &&
        (checkout.address.address.isEmpty ||
            checkout.address.apartmentOrOffice.isEmpty)) {
      throw RestaurantException("Укажите адрес доставки");
    }
    if (checkout.orderType == OrderType.pickup &&
        checkout.pickupPoint == null) {
      throw RestaurantException("Укажите точку самовывоза");
    }
    if (checkout.deliveryTime == DeliveryTimeType.none ||
        (checkout.deliveryTime == DeliveryTimeType.certainTime &&
            checkout.certainTimeOrder.isEmpty)) {
      throw RestaurantException("Укажите время доставки");
    }
    // int orderTotal = (cartBloc.state as CartLoaded).cart.subtotal -
    //     (cartBloc.state as CartLoaded).cart.discount +
    //     checkout.deliveryCost;
    // int? changeWith = int.tryParse(change);

    // if (checkout.paymentMethod == PaymentMethod.cash && changeWith == null) {
    //   throw RestaurantException(
    //       "Укажите корректное значение для поля \"Сдача с\"");
    // }
    // if (checkout.paymentMethod == PaymentMethod.cash &&
    //     (changeWith! == 0 || changeWith < orderTotal)) {
    //   throw RestaurantException(
    //       "Укажите корректное значение для поля \"Сдача с\"");
    // }

    if (checkout.organizationID.isEmpty) {
      throw RestaurantException("Произошла непредвиденная ошибка. Код 1337");
    }
  }

  //Generate unique id for order
  int generateOrderID() {
    String id =
        "${DateFormat('yyMMdd').format(DateTime.now())}${1000 + Random().nextInt(9000)}";
    return int.parse(id);
  }
}
