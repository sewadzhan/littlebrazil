import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/data/models/promocode.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';

part 'promocode_event.dart';
part 'promocode_state.dart';

//Bloc for promocode realization
class PromocodeBloc extends Bloc<PromocodeEvent, PromocodeState> {
  final FirestoreRepository firestoreRepository;
  final CartBloc cartBLoc;
  final CurrentUserBloc currentUserBloc;

  PromocodeBloc(this.firestoreRepository, this.cartBLoc, this.currentUserBloc)
      : super(PromocodeInitial()) {
    on<LoadPromocodes>(loadPromocodesToState);
    on<PromocodeSubmited>(promocodeSubmitedToState);
  }

  loadPromocodesToState(
      LoadPromocodes event, Emitter<PromocodeState> emit) async {
    try {
      List<Promocode> promocodes = await firestoreRepository.getPromocodes();
      emit(PromocodeLoadSuccess(promocodes));
    } catch (e) {
      emit(PromocodeFailure(e.toString()));
    }
  }

  promocodeSubmitedToState(
      PromocodeSubmited event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadSuccess && cartBLoc.state is CartLoaded) {
        var promocodes = (state as PromocodeLoadSuccess).promocodes;
        emit(PromocodeSubmitLoading());
        var list = promocodes.where((element) => element.isActive).where(
            (element) =>
                element.code.toLowerCase() == event.code.trim().toLowerCase());

        if (list.isNotEmpty) {
          //Checking the hourly limit of promocode
          if (!checkHourlyLimit(list.first)) {
            emit(const PromocodeFailure("promoCodeNotApplicable"));
            emit(PromocodeLoadSuccess(promocodes));
            return;
          }

          //Checking the use of promocode if it can be used only once
          var verification1 = await canBeOnlyOnceVerification(list.first);
          if (!verification1) {
            emit(const PromocodeFailure("promoCodeSingleUse"));
            emit(PromocodeLoadSuccess(promocodes));
            return;
          }

          //Successful applying
          cartBLoc.add(CartPromocodeApplied(list.first));
          emit(PromocodeSubmitSuccess());
        } else {
          emit(const PromocodeFailure("invalidPromoCode"));
        }

        emit(PromocodeLoadSuccess(promocodes));
        return;
      }
      emit(const PromocodeFailure("unexpectedError"));
    } catch (e) {
      emit(PromocodeFailure(e.toString()));
    }
  }

  //Checking the use of promocode if it can be used only once
  Future<bool> canBeOnlyOnceVerification(Promocode promocode) async {
    if (promocode.canBeUsedOnlyOnce) {
      var usedPromocodes = await firestoreRepository.getUsedPromocodesOfUser(
          (currentUserBloc.state as CurrentUserRetrieveSuccessful)
              .user
              .phoneNumber);
      if (usedPromocodes
          .where((element) => element == promocode.code)
          .isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  //Check hourly limit for promocode
  bool checkHourlyLimit(Promocode promocode) {
    if (promocode.startTimeLimit.isNotEmpty &&
        promocode.finishTimeLimit.isNotEmpty) {
      var dateTime = DateTime.now();
      var dateFormat = DateFormat("dd.MM.yyyy HH:mm");
      var dateTimeOpen = dateFormat.parse(
          "${dateTime.day}.${dateTime.month}.${dateTime.year} ${promocode.startTimeLimit}");
      var dateTimeClose = dateFormat.parse(
          "${dateTime.day}.${dateTime.month}.${dateTime.year} ${promocode.finishTimeLimit}");

      //Check for close working time is on next day
      if (dateTimeClose.isBefore(dateTimeOpen)) {
        if (dateTime.isAfter(dateTimeClose) &&
            dateTime.isBefore(dateTimeOpen)) {
          return false;
        }
      } else if (!(dateTime.isAfter(dateTimeOpen) &&
          dateTime.isBefore(dateTimeClose))) {
        return false;
      }
    }
    return true;
  }
}
