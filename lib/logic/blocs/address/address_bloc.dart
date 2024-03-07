import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/data/models/add_address.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:uuid/uuid.dart';

part 'address_event.dart';
part 'address_state.dart';

//Bloc for customer's addresses of delivery
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final FirestoreRepository firestoreRepository;
  final CheckoutBloc checkoutBloc;
  final uuid = const Uuid();

  AddressBloc(this.firestoreRepository, this.checkoutBloc)
      : super(AddressInitial()) {
    on<LoadAddresses>(loadAddressesToState);
    on<AddressAdded>(addressAddedToState);
    on<AddressRemoved>(addressRemovedToState);
    on<AddressSetToInitial>(addressSetToInitialToState);
  }

  //Load customer's addresses from DB
  loadAddressesToState(LoadAddresses event, Emitter<AddressState> emit) async {
    if (state is AddressInitial) {
      try {
        emit(AddressLoading());

        List<Address> addresses =
            await firestoreRepository.getAddressesOfUser(event.phoneNumber);

        emit(AddressLoaded(addresses));

        //Change selected address in Checkout page after loading addresses
        //from Firestore because of empty address in initial checkout bloc
        if (addresses.isNotEmpty) {
          checkoutBloc.add(CheckoutAddressChanged(addresses[0]));
        }
      } catch (e) {
        emit(const AddressErrorState("Произошла непредвиденная ошибка"));
      }
    }
  }

  //Adding address from accouunt
  addressAddedToState(AddressAdded event, Emitter<AddressState> emit) async {
    if (state is AddressLoaded) {
      var currentState = state;
      try {
        emit(AddressLoading());

        //Limit number of addresses
        if ((currentState as AddressLoaded).addresses.length == 10) {
          emit(const AddressErrorState("Количество адресов превышает лимит"));
          emit(currentState);
          return;
        }

        //Address data validation
        if (event.model.address.isEmpty || event.apartment.isEmpty) {
          emit(const AddressErrorState("Введите все необходимые данные"));
          emit(currentState);
          return;
        } else if (!event.model.canBeDelivered) {
          emit(const AddressErrorState(
              "Доставка в данный момент не осуществляется по данному адресу"));
          emit(currentState);
          return;
        }

        Address address = Address(
            id: uuid.v4(),
            address: event.model.address,
            apartmentOrOffice: event.apartment,
            geopoint: event.model.marker!);

        List<Address> newAddressesList = List.from(currentState.addresses)
          ..add(address);

        await firestoreRepository.addAddress(event.phoneNumber, address);
        emit(AddressSuccessfullAdded());
        emit(AddressLoaded(newAddressesList));

        //Change selected address in Checkout page after adding new address
        checkoutBloc.add(CheckoutAddressChanged(address));
      } catch (e) {
        emit(const AddressErrorState("Произошла непредвиденная ошибка"));
        emit(AddressLoaded((currentState as AddressLoaded).addresses));
      }
    }
  }

  //Removing address from accouunt
  addressRemovedToState(
      AddressRemoved event, Emitter<AddressState> emit) async {
    if (state is AddressLoaded) {
      var currentState = state;
      try {
        await firestoreRepository.removeAddress(
            event.phoneNumber, event.address);
        List<Address> newList = List.from((state as AddressLoaded).addresses)
          ..remove(event.address);
        emit(AddressLoaded(newList));

        //Change address in Checkout page after removing some address
        if (newList.isEmpty) {
          checkoutBloc.add(const CheckoutAddressChanged(null));
        } else {
          checkoutBloc.add(CheckoutAddressChanged(newList[0]));
        }
      } catch (e) {
        emit(const AddressErrorState("Произошла непредвиденная ошибка"));
        emit(AddressLoaded((currentState as AddressLoaded).addresses));
      }
    }
  }

  //Set to initial state
  addressSetToInitialToState(
      AddressSetToInitial event, Emitter<AddressState> emit) {
    if (state is AddressLoaded) {
      emit(AddressInitial());
    }
  }
}
