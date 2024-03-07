import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/order.dart';

part 'bottom_sheet_state.dart';

//Cubit for showing bottom sheets in app
class BottomSheetCubit extends Cubit<BottomSheetState> {
  BottomSheetCubit() : super(BottomSheetInitial());

  //Showing congratulations of getting gift in bottom sheet
  // showGiftBottomSheet(GiftGoal giftGoal) {
  //   emit(GiftBottomSheetShowState(giftGoal));
  // }

  //Showing not working bottom sheet
  showNotWorkingBottomSheet(String openHour, String closeHour) {
    emit(NotWorkingBottomSheetShowState(openHour, closeHour));
  }

  //Showing cashback bottom sheet
  showCashbackBottomSheet(Order order) {
    emit(CashbackBottomSheetShowState(order));
  }

  //Showing update app bottom sheet
  showUpdateAppBottomSheet(String playMarketUrl, String appStoreUrl) {
    emit(UpdateAppBottomSheetShowState(playMarketUrl, appStoreUrl));
  }

  //Showing the pay instruction
  // showPayInstructionBottomSheet() {
  //   emit(const PayInstructionBottomSheetShowState());
  // }
}
