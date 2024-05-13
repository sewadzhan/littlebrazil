import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'otp_section_state.dart';

//Cubit for OTP Section
class OTPSectionCubit extends Cubit<OTPSectionState> {
  late Timer timer;
  OTPSectionCubit() : super(const InitialOTPSectionState());

  //Set the initial state of cubit
  void setToInitialState() {
    emit(const InitialOTPSectionState());
    if (timer.isActive) {
      timer.cancel();
    }
  }

  //Save actual data of user during phone verification
  void saveOTPData({required String phoneNumber, required String name}) {
    emit(OTPSentState(name: name, phoneNumber: phoneNumber));
  }

  //Start resend timer in OTP Section
  void startResendTimer() {
    if (state is OTPSentState) {
      int start = 60;
      OTPSentState currentState = state as OTPSentState;
      const Duration onsec = Duration(seconds: 1);
      emit(ResendSMSTimerStarted(
          seconds: start,
          name: currentState.name,
          phoneNumber: currentState.phoneNumber));
      timer = Timer.periodic(onsec, (timer) {
        if (start != 1) {
          start--;
          emit(ResendSMSTimerStarted(
              seconds: start,
              name: currentState.name,
              phoneNumber: currentState.phoneNumber));
        } else {
          timer.cancel();
          emit(OTPSentState(
              name: currentState.name, phoneNumber: currentState.phoneNumber));
        }
      });
    }
  }
}
