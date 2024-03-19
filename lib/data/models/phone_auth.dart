import 'package:equatable/equatable.dart';

enum PhoneAuthModelState {
  codeSent,
  autoVerified,
  error,
  verified,
}

//Model for authentication via phone number
class PhoneAuthModel extends Equatable {
  final PhoneAuthModelState phoneAuthModelState;
  final String? verificationId;
  final int? verificationToken;
  final String? uid;
  final bool isNewUser;

  const PhoneAuthModel({
    required this.phoneAuthModelState,
    this.verificationId,
    this.verificationToken,
    this.uid,
    this.isNewUser = false,
  });

  PhoneAuthModel copyWith({
    PhoneAuthModelState? phoneAuthModelState,
    String? verificationId,
    int? verificationToken,
    String? uid,
  }) {
    return PhoneAuthModel(
      phoneAuthModelState: phoneAuthModelState ?? this.phoneAuthModelState,
      verificationId: verificationId ?? this.verificationId,
      verificationToken: verificationToken ?? this.verificationToken,
      uid: uid ?? this.uid,
    );
  }

  @override
  List<Object?> get props =>
      [phoneAuthModelState, verificationId, verificationToken, uid];
}
