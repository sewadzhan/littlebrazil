part of 'otp_section_cubit.dart';

abstract class OTPSectionState extends Equatable {
  const OTPSectionState();

  @override
  List<Object?> get props => [];
}

class InitialOTPSectionState extends OTPSectionState {
  const InitialOTPSectionState();
}

class OTPSentState extends OTPSectionState {
  final String phoneNumber;
  final String name;

  const OTPSentState({required this.phoneNumber, required this.name});

  @override
  List<Object?> get props => [phoneNumber, name];
}

class ResendSMSTimerStarted extends OTPSentState {
  final int seconds;

  const ResendSMSTimerStarted(
      {required this.seconds, required super.phoneNumber, required super.name});

  @override
  List<Object?> get props => [seconds, phoneNumber, name];
}
