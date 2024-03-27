part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

//Reset all states
class PhoneAuthReset extends PhoneAuthEvent {}

//Verify phone number by sending OTP event
class PhoneAuthNumberVerified extends PhoneAuthEvent {
  final String phoneNumber;
  final int? resendToken;

  const PhoneAuthNumberVerified({
    required this.phoneNumber,
    this.resendToken,
  });

  @override
  List<Object> get props => [phoneNumber];
}

// Check SMS OTP event
class PhoneAuthCodeVerified extends PhoneAuthEvent {
  final String verificationId;
  final int? resendToken;
  final String smsCode;

  const PhoneAuthCodeVerified(
      {required this.verificationId, required this.smsCode, this.resendToken});

  @override
  List<Object> get props => [smsCode];
}

//Time out to get SMS OTP event
class PhoneAuthCodeAutoRetrevalTimeout extends PhoneAuthEvent {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthCodeAutoRetrevalTimeout(this.verificationId,
      {this.resendToken});

  @override
  List<Object> get props => [verificationId];
}

//SMS OTP was successfully sent event
class PhoneAuthCodeSent extends PhoneAuthEvent {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthCodeSent({
    required this.verificationId,
    required this.resendToken,
  });

  @override
  List<Object> get props => [verificationId];
}

//SMS OTP was successfully resent event
class PhoneAuthCodeResent extends PhoneAuthEvent {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthCodeResent({
    required this.verificationId,
    required this.resendToken,
  });

  @override
  List<Object> get props => [verificationId];
}

//Incorrect SMS OTP event
class PhoneAuthVerificationFailed extends PhoneAuthEvent {
  final String message;

  const PhoneAuthVerificationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

//Successful log in/sign up user via phone number
class PhoneAuthVerificationCompleted extends PhoneAuthEvent {
  final String? uid;
  final bool isNewUser;

  const PhoneAuthVerificationCompleted(this.uid, this.isNewUser);

  @override
  List<Object?> get props => [uid];
}

//Create new user in Cloud Firestore
class CreateNewUserInFirestore extends PhoneAuthEvent {
  final String phoneNumber;
  final String name;
  final int? welcomeBonus;

  const CreateNewUserInFirestore(
      {required this.phoneNumber, required this.name, this.welcomeBonus});

  @override
  List<Object?> get props => [phoneNumber, name, welcomeBonus];
}
