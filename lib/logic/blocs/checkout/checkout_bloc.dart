import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/delivery_point.dart';
import 'package:littlebrazil/data/models/delivery_zone.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/view/config/map_tools.dart';

part 'checkout_event.dart';

//Bloc for "Checkout" page
class CheckoutBloc extends Bloc<CheckoutEvent, Checkout> {
  final DeliveryZonesCubit deliveryZonesCubit;
  final CartBloc cartBloc;

  CheckoutBloc(this.deliveryZonesCubit, this.cartBloc)
      : super(const Checkout(
            orderType: OrderType.delivery,
            address: Address(
                id: "",
                address: "",
                apartmentOrOffice: "",
                geopoint: MapLatLng(latitude: 0, longitude: 0)),
            deliveryTime: DeliveryTimeType.fast,
            numberOfCutlery: 1,
            paymentMethod: PaymentMethod.bankCard,
            pickupPoint: null,
            certainTimeOrder: "",
            certainDayOrder: "",
            deliveryCost: 0,
            organizationID: "",
            comments: "")) {
    on<CheckoutAddressChanged>(checkoutAddressChangedToState);
    on<CheckoutOrderTypeChanged>(checkoutOrderTypeChangedToState);
    on<CheckoutDeliveryTimeTypeChanged>(checkoutDeliveryTimeTypeChangedToState);
    on<CheckoutNumberOfCutleryIncreased>(
        checkoutNumberOfCutleryIncreasedToState);
    on<CheckoutNumberOfCutleryDecreased>(
        checkoutNumberOfCutleryDecreasedToState);
    on<CheckoutPaymentMethodChanged>(checkoutPaymentMethodChangedToState);
    on<CheckoutPickupPointChanged>(checkoutPickupPointChangedToState);
    on<CheckoutCertainTimeOrderChanged>(checkoutCertainTimeOrderChangedToState);
    on<CheckoutCommentsChanged>(checkoutCommentsChangedToState);
  }

  //Change address
  checkoutAddressChangedToState(
      CheckoutAddressChanged event, Emitter<Checkout> emit) {
    if (deliveryZonesCubit.state is DeliveryZonesLoadedState) {
      //Case when last address was deleted in My Addresses Screen
      if (event.address == null) {
        var emptyAddress = const Address(
            id: "",
            address: "",
            apartmentOrOffice: "",
            geopoint: MapLatLng(latitude: 0, longitude: 0));
        emit(state.copyWith(
            address: emptyAddress, deliveryCost: 0, organizationID: null));
        return;
      }

      //Find delivery zone of chosen address
      List<DeliveryZone> zones =
          (deliveryZonesCubit.state as DeliveryZonesLoadedState).deliveryZones;
      DeliveryZone? zone =
          MapTools.getIntersectedZone(zones, event.address!.geopoint);

      if (zone != null) {
        emit(state.copyWith(
            address: event.address,
            deliveryCost: zone.cost,
            organizationID: zone.organizationID));
      }
    }
  }

  //Change order type (delivery or local pickup)
  checkoutOrderTypeChangedToState(
      CheckoutOrderTypeChanged event, Emitter<Checkout> emit) {
    //Changing organization ID after changing orderType
    if (event.orderType == OrderType.pickup) {
      emit(state.copyWith(
          orderType: event.orderType,
          deliveryCost: 0,
          organizationID: state.pickupPoint != null
              ? state.pickupPoint!.organizationID
              : ""));
    } else if (event.orderType == OrderType.delivery) {
      //Find delivery zone of chosen address
      List<DeliveryZone> zones =
          (deliveryZonesCubit.state as DeliveryZonesLoadedState).deliveryZones;
      DeliveryZone? zone =
          MapTools.getIntersectedZone(zones, state.address.geopoint);

      emit(state.copyWith(
          orderType: event.orderType,
          deliveryCost: zone != null ? zone.cost : 0,
          organizationID: zone != null ? zone.organizationID : ""));
    }
  }

  //Change delivery time type (fast or certain delivery time)
  checkoutDeliveryTimeTypeChangedToState(
      CheckoutDeliveryTimeTypeChanged event, Emitter<Checkout> emit) {
    emit(state.copyWith(deliveryTime: event.deliveryTimeType));
  }

  //Increase number of persons
  checkoutNumberOfCutleryIncreasedToState(
      CheckoutNumberOfCutleryIncreased event, Emitter<Checkout> emit) {
    if (state.numberOfCutlery < 25) {
      int result = state.numberOfCutlery + 1;
      emit(state.copyWith(numberOfCutlery: result));
    }
  }

  //Decrease number of persons
  checkoutNumberOfCutleryDecreasedToState(
      CheckoutNumberOfCutleryDecreased event, Emitter<Checkout> emit) {
    if (state.numberOfCutlery > 1) {
      int result = state.numberOfCutlery - 1;
      emit(state.copyWith(numberOfCutlery: result));
    }
  }

  //Change payment method
  checkoutPaymentMethodChangedToState(
      CheckoutPaymentMethodChanged event, Emitter<Checkout> emit) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  //Change pickup point
  checkoutPickupPointChangedToState(
      CheckoutPickupPointChanged event, Emitter<Checkout> emit) {
    emit(state.copyWith(
        pickupPoint: event.pickupPoint,
        organizationID: event.pickupPoint.organizationID));
  }

  //Change certain time order
  checkoutCertainTimeOrderChangedToState(
      CheckoutCertainTimeOrderChanged event, Emitter<Checkout> emit) {
    emit(state.copyWith(
        certainTimeOrder: event.certainTimeOrder,
        certainDayOrder: event.certainDayOrder));
  }

  //Change comments
  checkoutCommentsChangedToState(
      CheckoutCommentsChanged event, Emitter<Checkout> emit) {
    emit(state.copyWith(
      comments: event.comments,
    ));
  }

  //Change saved card for payment
  // checkoutSavedCardOrderChangedToState(
  //     CheckoutSavedCardOrderChanged event, Emitter<Checkout> emit) {
  //   emit(state.copyWith(savedCard: event.card));
  // }
}
