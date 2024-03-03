part of 'bottom_sheet_cubit.dart';

abstract class BottomSheetState extends Equatable {
  const BottomSheetState();

  @override
  List<Object> get props => [];
}

class BottomSheetInitial extends BottomSheetState {}

//State for showing not working bottom sheet
class NotWorkingBottomSheetShowState extends BottomSheetState {
  final String openHour;
  final String closeHour;

  const NotWorkingBottomSheetShowState(this.openHour, this.closeHour);

  @override
  List<Object> get props => [openHour, closeHour];
}

//State for showing gift bottom sheet
// class GiftBottomSheetShowState extends BottomSheetState {
//   final GiftGoal giftGoal;

//   const GiftBottomSheetShowState(this.giftGoal);

//   @override
//   List<Object> get props => [giftGoal.categoryID, giftGoal.goal];
// }

//State for showing cashback bottom sheet in Checkout page
// class CashbackBottomSheetShowState extends BottomSheetState {
//   final Order order;

//   const CashbackBottomSheetShowState(this.order);

//   @override
//   List<Object> get props => [order];
// }

//State for showing update app bottom sheet
class UpdateAppBottomSheetShowState extends BottomSheetState {
  final String playMarketUrl;
  final String appStoreUrl;

  const UpdateAppBottomSheetShowState(this.playMarketUrl, this.appStoreUrl);

  @override
  List<Object> get props => [playMarketUrl, appStoreUrl];
}

//State for showing the pay instruction
// class PayInstructionBottomSheetShowState extends BottomSheetState {
//   const PayInstructionBottomSheetShowState();

//   @override
//   List<Object> get props => [];
// }
