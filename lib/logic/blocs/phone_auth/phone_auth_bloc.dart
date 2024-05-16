import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/repositories/auth_repository.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/data/models/phone_auth.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

//Bloc for authentication via phone number
class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final AuthRepository authRepository;
  final FirestoreRepository firestoreRepository;
  PhoneAuthBloc(
      {required this.authRepository, required this.firestoreRepository})
      : super(const PhoneAuthInitial()) {
    on<PhoneAuthReset>(((event, emit) => emit(const PhoneAuthInitial())));
    on<PhoneAuthNumberVerified>(phoneAuthNumberVerifiedToState);
    on<PhoneAuthCodeSent>((event, emit) => emit(
        PhoneAuthNumberVerificationSuccess(
            verificationId: event.verificationId,
            resendToken: event.resendToken)));
    on<PhoneAuthCodeResent>(((event, emit) => emit(
        PhoneAuthNumberVerificationResendSuccess(
            verificationId: event.verificationId,
            resendToken: event.resendToken))));
    on<PhoneAuthVerificationFailed>(((event, emit) =>
        emit(PhoneAuthNumberVerificationFailure(event.message))));
    on<PhoneAuthVerificationCompleted>(((event, emit) => emit(
        PhoneAuthCodeVerificationSuccess(
            uid: event.uid, isNewUser: event.isNewUser))));
    on<PhoneAuthCodeAutoRetrevalTimeout>(((event, emit) =>
        emit(PhoneAuthCodeAutoRetrevalTimeoutComplete(event.verificationId))));
    on<PhoneAuthCodeVerified>((phoneAuthCodeVerifiedToState));
    on<CreateNewUserInFirestore>(createNewUserInFirestoreToState);
  }

  //Verify phone number by sending SMS OTP
  void phoneAuthNumberVerifiedToState(
      PhoneAuthNumberVerified event, Emitter<PhoneAuthState> emit) async {
    try {
      var phone = event.phoneNumber.replaceAll(' ', '');
      emit(const PhoneAuthLoading());

      if (phone.isEmpty) {
        emit(const PhoneAuthNumberVerificationFailure("invalidPhoneNumber"));
        return;
      } else if (phone.substring(0, 1) == '7') {
        phone = phone.replaceFirst(RegExp(r'7'), '+7');
      } else if (phone.substring(0, 1) == '8') {
        phone = phone.replaceFirst(RegExp(r'8'), '+7');
      }

      if (!isValid(phone)) {
        emit(const PhoneAuthNumberVerificationFailure("invalidPhoneNumber"));
        return;
      }
      await authRepository.verifyPhoneNumber(
        mobileNumber: phone,
        resendToken: event.resendToken,
        onCodeAutoRetrievalTimeOut: _onCodeAutoRetrievalTimeout,
        onCodeSent: event.resendToken == null ? _onCodeSent : _onCodeResent,
        onVerificaitonFailed: _onVerificationFailed,
        onVerificationCompleted: _onVerificationCompleted,
      );
    } catch (e) {
      emit(PhoneAuthNumberVerificationFailure(e.toString()));
    }
  }

  //Verify SMS OTP to log in or sign up user
  void phoneAuthCodeVerifiedToState(
      PhoneAuthCodeVerified event, Emitter<PhoneAuthState> emit) async {
    try {
      emit(const PhoneAuthLoading());
      PhoneAuthModel phoneAuthModel =
          await authRepository.loginWithSMSVerificationCode(
              smsCode: event.smsCode, verificationId: event.verificationId);
      add(PhoneAuthVerificationCompleted(
          phoneAuthModel.uid, phoneAuthModel.isNewUser));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-verification-code":
          emit(PhoneAuthCodeVerificationFailure("invalidVerificationCode",
              event.verificationId, event.resendToken ?? 0));
          break;
        case "network-request-failed":
          emit(PhoneAuthCodeVerificationFailure("noInternetConnection",
              event.verificationId, event.resendToken!));
          break;
        default:
          emit(PhoneAuthCodeVerificationFailure(
              e.toString(), event.verificationId, event.resendToken!));
      }
    }
  }

  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    final PhoneAuthModel phoneAuthModel =
        await authRepository.loginWithCredential(credential: credential);
    if (phoneAuthModel.phoneAuthModelState == PhoneAuthModelState.verified) {
      add(PhoneAuthVerificationCompleted(
          phoneAuthModel.uid, phoneAuthModel.isNewUser));
    }
  }

  void _onVerificationFailed(FirebaseAuthException exception) {
    switch (exception.code) {
      case "network-request-failed":
        add(const PhoneAuthVerificationFailed(message: "noInternetConnection"));
        break;
    }
  }

  void _onCodeSent(String verificationId, int? resendToken) {
    log('Print code is successfully sent with verification id $verificationId and token $resendToken');

    add(PhoneAuthCodeSent(
      resendToken: resendToken,
      verificationId: verificationId,
    ));
  }

  void _onCodeResent(String verificationId, int? resendToken) {
    log('Print code is successfully sent with verification id $verificationId and token $resendToken');

    add(PhoneAuthCodeResent(
      resendToken: resendToken,
      verificationId: verificationId,
    ));
  }

  void createNewUserInFirestoreToState(
      CreateNewUserInFirestore event, Emitter<PhoneAuthState> emit) async {
    var phone = event.phoneNumber;

    try {
      await firestoreRepository.writeNewUser(
          phone.replaceAll(' ', ''), event.name, event.welcomeBonus);
      emit(const PhoneAuthCreateUserSuccess());
    } catch (e) {
      add(const PhoneAuthVerificationFailed(message: "createUserFailed"));
    }
  }

  //Auto retrieval has timed out for verification ID
  void _onCodeAutoRetrievalTimeout(String verificationId) {
    log('Auto retrieval has timed out for verification ID $verificationId');
    add(PhoneAuthCodeAutoRetrevalTimeout(verificationId));
  }

  //Check validity of phone number via regular expression
  bool isValid(String phoneNumber) {
    RegExp phoneRegExp = RegExp(
      r'^((\+7)+([0-9]){10})$',
    );
    return phoneRegExp.hasMatch(phoneNumber);
  }
}
