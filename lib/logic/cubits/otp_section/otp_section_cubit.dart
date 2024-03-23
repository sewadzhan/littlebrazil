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
  }

  //Save actual data of user during phone verification
  void saveOTPData({required String phoneNumber, required String name}) {
    emit(OTPSentState(name: name, phoneNumber: phoneNumber));
  }

  //Start resend timer in OTP Section
  void startResendTimer() {
    if (state is OTPSentState) {
      int start = 50;
      OTPSentState currentState = state as OTPSentState;
      const Duration onsec = Duration(seconds: 1);
      timer = Timer.periodic(onsec, (timer) {
        if (start == 0) {
          timer.cancel();
          emit(OTPSentState(
              name: currentState.name, phoneNumber: currentState.phoneNumber));
        } else {
          start--;
          emit(ResendSMSTimerStarted(
              seconds: start,
              name: currentState.name,
              phoneNumber: currentState.phoneNumber));
        }
      });
    }
  }
}
