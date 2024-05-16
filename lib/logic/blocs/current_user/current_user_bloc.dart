import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/restaurant_user.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

//Bloc for current user information
class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final FirestoreRepository firestoreRepository;
  final AddressBloc addressBloc;
  final CheckoutBloc checkoutBloc;
  final AuthCubit authCubit;
  late StreamSubscription authSubscription;
  bool isNewUser = false;

  CurrentUserBloc(this.firestoreRepository, this.addressBloc, this.authCubit,
      this.checkoutBloc)
      : super(CurrentUserInitial()) {
    on<CurrentUserRetrieved>(currentUserRetrievedToState);
    on<CurrentUserSet>(currentUserSetToState);
    on<CurrentUserCashbackChanged>(currentUserCashbackChangedToState);
    on<CurrentUserSignedOut>(currentUserSignedOutToState);
    on<CurrentUserRemoved>(currentUserRemovedToState);

    authSubscription = authCubit.stream.listen((User? authState) {
      if (authState != null && authState.phoneNumber != null) {
        add(CurrentUserRetrieved(authState.phoneNumber!));
      }
    });
  }

  currentUserRetrievedToState(
      CurrentUserRetrieved event, Emitter<CurrentUserState> emit) async {
    if (state is CurrentUserInitial) {
      try {
        RestaurantUser user =
            await firestoreRepository.retrieveUser(event.phoneNumber);
        emit(CurrentUserRetrieveSuccessful(user));
        //Retrieving all user addresses
        addressBloc.add(LoadAddresses(event.phoneNumber));
      } catch (e) {
        emit(CurrentUserRetrieveFailure());
      }
    }
  }

  currentUserSetToState(CurrentUserSet event, Emitter<CurrentUserState> emit) {
    if (state is CurrentUserRetrieveSuccessful) {
      emit(CurrentUserRetrieveSuccessful(
          (state as CurrentUserRetrieveSuccessful).user.copyWith(
              name: event.user.name,
              email: event.user.email,
              birthday: event.user.birthday)));
    }
  }

  //Change user cashback value in Profile Screen
  currentUserCashbackChangedToState(
      CurrentUserCashbackChanged event, Emitter<CurrentUserState> emit) {
    if (state is CurrentUserRetrieveSuccessful) {
      emit(CurrentUserRetrieveSuccessful(
          (state as CurrentUserRetrieveSuccessful)
              .user
              .copyWith(cashback: event.cashback)));
    }
  }

  //Sign out from account
  currentUserSignedOutToState(
      CurrentUserSignedOut event, Emitter<CurrentUserState> emit) {
    if (state is CurrentUserRetrieveSuccessful) {
      emit(CurrentUserInitial());
      addressBloc.add(AddressSetToInitial());
      checkoutBloc.add(const CheckoutAddressChanged(null));
    }
  }

  //Remove current account
  currentUserRemovedToState(
      CurrentUserRemoved event, Emitter<CurrentUserState> emit) {
    if (state is CurrentUserRetrieveSuccessful) {
      var phoneNumber =
          (state as CurrentUserRetrieveSuccessful).user.phoneNumber;
      emit(CurrentUserInitial());
      addressBloc.add(AddressSetToInitial());
      checkoutBloc.add(const CheckoutAddressChanged(null));
      firestoreRepository.deleteUser(phoneNumber);
    }
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
