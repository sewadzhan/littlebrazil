import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/delivery_point.dart';
import 'package:littlebrazil/data/models/delivery_zone.dart';
import 'package:littlebrazil/data/models/maplatlng.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/logic/cubits/extra_cutlery/extra_cutlery_cubit.dart';
import 'package:littlebrazil/view/config/map_tools.dart';

part 'checkout_event.dart';

//Bloc for "Checkout" page
class CheckoutBloc extends Bloc<CheckoutEvent, Checkout> {
  final DeliveryZonesCubit deliveryZonesCubit;
  final CartBloc cartBloc;
  final ExtraCutleryCubit extraCutleryCubit;

  CheckoutBloc(this.deliveryZonesCubit, this.cartBloc, this.extraCutleryCubit)
      : super(const Checkout(
          orderType: OrderType.delivery,
          address: Address(
              id: "",
              address: "",
              apartmentOrOffice: "",
              geopoint: MapLatLng(latitude: 0, longitude: 0)),
          deliveryTime: DeliveryTimeType.none,
          numberOfPersons: 1,
          paymentMethod: PaymentMethod.bankCard,
          pickupPoint: null,
          certainTimeOrder: "",
          deliveryCost: 0,
          organizationID: "",
        )) {
    on<CheckoutAddressChanged>(checkoutAddressChangedToState);
    on<CheckoutOrderTypeChanged>(checkoutOrderTypeChangedToState);
    on<CheckoutDeliveryTimeTypeChanged>(checkoutDeliveryTimeTypeChangedToState);
    on<CheckoutNumberOfPersonsChanged>(checkoutNumberOfPersonsChangedToState);
    on<CheckoutPaymentMethodChanged>(checkoutPaymentMethodChangedToState);
    on<CheckoutPickupPointChanged>(checkoutPickupPointChangedToState);
    on<CheckoutCertainTimeOrderChanged>(checkoutCertainTimeOrderChangedToState);
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

  //Change number of persons
  checkoutNumberOfPersonsChangedToState(
      CheckoutNumberOfPersonsChanged event, Emitter<Checkout> emit) {
    //When extra cutlery cubit is not initialized
    if (extraCutleryCubit.state is ExtraCutleryNotInitState) {
      if (event.numberOfPersons > 0 && event.numberOfPersons < 50) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
      }
      return;
    }

    if (event.returnToDefault) {
      emit(state.copyWith(numberOfPersons: 1));
      extraCutleryCubit.hidePanel();
      return;
    }
    if (event.numberOfPersons > 0 && event.numberOfPersons <= 50) {
      //Subtotal without extra cutlery position
      int cartSubtotal = (cartBloc.state as CartLoaded).cart.items.fold(0,
          (previousValue, element) {
        if (element.product.rmsID !=
            (extraCutleryCubit.state as ExtraCutleryLoadedState)
                .cutleryProduct
                .rmsID) {
          return previousValue + element.product.price * element.count;
        }
        return previousValue;
      });

      if (cartSubtotal <= 5000 && event.numberOfPersons < 2) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 5000 &&
          cartSubtotal <= 10000 &&
          event.numberOfPersons < 4) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 10000 &&
          cartSubtotal <= 16000 &&
          event.numberOfPersons < 8) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 16000 &&
          cartSubtotal <= 20000 &&
          event.numberOfPersons < 10) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 20000 &&
          cartSubtotal <= 30000 &&
          event.numberOfPersons < 20) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 30000 &&
          cartSubtotal <= 50000 &&
          event.numberOfPersons < 30) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (cartSubtotal > 50000) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        extraCutleryCubit.hidePanel();
      } else if (event.numberOfPersons == 2 ||
          event.numberOfPersons == 4 ||
          event.numberOfPersons == 8 ||
          event.numberOfPersons == 10 ||
          event.numberOfPersons == 20 ||
          event.numberOfPersons == 30) {
        emit(state.copyWith(numberOfPersons: event.numberOfPersons));
        //Show the extra cutlery panel
        extraCutleryCubit.showPanel();
      }
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
    emit(state.copyWith(certainTimeOrder: event.certainTimeOrder));
  }

  //Change saved card for payment
  // checkoutSavedCardOrderChangedToState(
  //     CheckoutSavedCardOrderChanged event, Emitter<Checkout> emit) {
  //   emit(state.copyWith(savedCard: event.card));
  // }
}
