import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cashback_data.dart';
import 'package:littlebrazil/data/models/cashback_gradation.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';

part 'cashback_event.dart';
part 'cashback_state.dart';

//Bloc for customer's addresses of delivery
class CashbackBloc extends Bloc<AddressEvent, CashbackState> {
  final FirestoreRepository firestoreRepository;
  final CurrentUserBloc currentUserBloc;

  CashbackBloc(this.firestoreRepository, this.currentUserBloc)
      : super(CashbackInitial()) {
    on<LoadCashbackData>(loadCashbackDataToState);
    on<CashbackDeposited>(cashbackDepositedToState);
    on<CashbackWithdrawed>(cashbackWithdrawedToState);
    on<CashbackActionChanged>(cashbackActionChangedToState);
  }

  //Load cashback info data (percent value, is enabled or not)
  loadCashbackDataToState(
      LoadCashbackData event, Emitter<CashbackState> emit) async {
    if (state is CashbackInitial) {
      try {
        emit(CashbackLoading());

        CashbackData cashbackData = await firestoreRepository.getCashbackData();

        emit(CashbackLoaded(cashbackData));
      } catch (e) {
        print("loadCashbackDataToState EXCEPTION: $e");
      }
    }
  }

  //Deposit cashback
  cashbackDepositedToState(
      CashbackDeposited event, Emitter<CashbackState> emit) async {
    if (state is CashbackLoaded) {
      // try {
      var previousState = state;
      emit(CashbackLoading());

      //Read current cashback from Firebase
      int currentCashback =
          await firestoreRepository.getUserCashback(event.phoneNumber);
      int newCashBack = currentCashback + event.value;
      //Deposit new cashback in Firebase
      await firestoreRepository.editUserCashback(
          event.phoneNumber, newCashBack);
      //Change cashback value in Profile screen
      currentUserBloc.add(CurrentUserCashbackChanged(newCashBack));

      emit(CashbackLoaded((previousState as CashbackLoaded)
          .cashbackData
          .copyWith(cashbackAction: CashbackAction.deposit)));
      // } catch (e) {
      //   print("cashbackDepositedToState EXCEPTION: $e");
      // }
    }
  }

  //Withdraw cashback
  cashbackWithdrawedToState(
      CashbackWithdrawed event, Emitter<CashbackState> emit) async {
    if (state is CashbackLoaded) {
      try {
        var previousState = state;
        emit(CashbackLoading());

        //Withdraw all cashback in Firebase
        await firestoreRepository.editUserCashback(event.phoneNumber, 0);
        //Change cashback value in Profile screen
        currentUserBloc.add(const CurrentUserCashbackChanged(0));

        emit(CashbackLoaded((previousState as CashbackLoaded)
            .cashbackData
            .copyWith(cashbackAction: CashbackAction.deposit)));
      } catch (e) {
        print("cashbackWithdrawedToState EXCEPTION: $e");
      }
    }
  }

  //Change cashback action for further cashback system actions after successfull payment
  cashbackActionChangedToState(
      CashbackActionChanged event, Emitter<CashbackState> emit) {
    if (state is CashbackLoaded) {
      emit(CashbackLoaded((state as CashbackLoaded)
          .cashbackData
          .copyWith(cashbackAction: event.cashbackAction)));
    }
  }
}
