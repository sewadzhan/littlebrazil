import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/restaurant_user.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

//Bloc for current user information
class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final FirestoreRepository firestoreRepository;
  final AddressBloc addressBloc;
  bool isNewUser = false;

  CurrentUserBloc(this.firestoreRepository, this.addressBloc)
      : super(CurrentUserInitial()) {
    on<CurrentUserRetrieved>(currentUserRetrievedToState);
    on<CurrentUserSet>(currentUserSetToState);
    on<CurrentUserCashbackChanged>(currentUserCashbackChangedToState);
    on<CurrentUserSignedOut>(currentUserSignedOutToState);
    on<CurrentUserRemoved>(currentUserRemovedToState);
  }

  currentUserRetrievedToState(
      CurrentUserRetrieved event, Emitter<CurrentUserState> emit) async {
    if (state is CurrentUserInitial) {
      try {
        // RestaurantUser user =
        //     await firestoreRepository.retrieveUser(event.phoneNumber);
        // emit(CurrentUserRetrieveSuccessful(user));
        //Retrieving all user addresses
        addressBloc.add(LoadAddresses("+77086053541"));
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
      // addressBloc.add(AddressSetToInitial());
      // payboxCardBloc.add(PayboxCardSetToInitial());
    }
  }

  //Remove current account
  currentUserRemovedToState(
      CurrentUserRemoved event, Emitter<CurrentUserState> emit) {
    if (state is CurrentUserRetrieveSuccessful) {
      var phoneNumber =
          (state as CurrentUserRetrieveSuccessful).user.phoneNumber;
      emit(CurrentUserInitial());
      // addressBloc.add(AddressSetToInitial());
      // payboxCardBloc.add(PayboxCardSetToInitial());
      firestoreRepository.deleteUser(phoneNumber);
    }
  }
}
