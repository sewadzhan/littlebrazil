part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

//Initial state
class PhoneAuthInitial extends PhoneAuthState {}

//Loading state
class PhoneAuthLoading extends PhoneAuthState {}

//Failed verification state
class PhoneAuthNumberVerificationFailure extends PhoneAuthState {
  final String message;

  const PhoneAuthNumberVerificationFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Time out to get SMS OTP state
class PhoneAuthCodeAutoRetrevalTimeoutComplete extends PhoneAuthState {
  final String verificationId;

  const PhoneAuthCodeAutoRetrevalTimeoutComplete(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

//SMS OTP was successfully sent state
class PhoneAuthNumberVerificationSuccess extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthNumberVerificationSuccess({
    required this.verificationId,
    required this.resendToken,
  });

  @override
  List<Object> get props => [verificationId];
}

//SMS OTP was successfully resent state
class PhoneAuthNumberVerificationResendSuccess extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthNumberVerificationResendSuccess({
    required this.verificationId,
    required this.resendToken,
  });

  @override
  List<Object> get props => [verificationId];
}

//Incorrect SMS OTP state
class PhoneAuthCodeVerificationFailure extends PhoneAuthState {
  final String message;
  final String verificationId;
  final int resendToken;

  const PhoneAuthCodeVerificationFailure(
      this.message, this.verificationId, this.resendToken);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeVerificationSuccess extends PhoneAuthState {
  final String? uid;
  final bool isNewUser;

  const PhoneAuthCodeVerificationSuccess(
      {required this.uid, required this.isNewUser});

  @override
  List<Object?> get props => [uid];
}

//User was successfully created in Firebase Cloud Firestore
class PhoneAuthCreateUserSuccess extends PhoneAuthState {}
