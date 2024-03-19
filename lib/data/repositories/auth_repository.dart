import 'package:firebase_auth/firebase_auth.dart';
import 'package:littlebrazil/data/providers/auth_firebase_provider.dart';
import 'package:littlebrazil/data/models/phone_auth.dart';

class AuthRepository {
  final AuthFirebaseProvider firebaseProvider;

  AuthRepository(this.firebaseProvider);

  //Get current user
  Future<void> signOut() async {
    firebaseProvider.signOut();
  }

  //Log out from account
  Future<bool> isSignedIn() async {
    return firebaseProvider.isSignedIn();
  }

  //Checking user is logged in or not
  Future<User?> getCurrentUser() async {
    return firebaseProvider.getUser();
  }

  //Sending SMS OTP to verify phone number
  Future<void> verifyPhoneNumber(
      {required String mobileNumber,
      required onVerificationCompleted,
      required onVerificaitonFailed,
      required onCodeSent,
      required onCodeAutoRetrievalTimeOut,
      required resendToken}) async {
    if (resendToken == null) {
      await firebaseProvider.verifyPhoneNumber(
        mobileNumber: mobileNumber,
        onVerificationCompleted: onVerificationCompleted,
        onVerificaitonFailed: onVerificaitonFailed,
        onCodeSent: onCodeSent,
        onCodeAutoRetrievalTimeOut: onCodeAutoRetrievalTimeOut,
      );
    } else {
      await firebaseProvider.resendOTP(
          mobileNumber: mobileNumber,
          onVerificationCompleted: onVerificationCompleted,
          onVerificaitonFailed: onVerificaitonFailed,
          onCodeSent: onCodeSent,
          onCodeAutoRetrievalTimeOut: onCodeAutoRetrievalTimeOut,
          resendToken: resendToken);
    }
  }

  //Log in or sign up via phone number after checking SMS OTP
  Future<PhoneAuthModel> loginWithSMSVerificationCode({
    required String smsCode,
    required String verificationId,
  }) async {
    final UserCredential userCredential =
        await firebaseProvider.loginWithSMSVerificationCode(
            verificationId: verificationId, smsCode: smsCode);
    final User? user = userCredential.user;

    if (user != null) {
      return PhoneAuthModel(
          phoneAuthModelState: PhoneAuthModelState.verified,
          uid: user.uid,
          isNewUser: userCredential.additionalUserInfo!.isNewUser);
    } else {
      return const PhoneAuthModel(
          phoneAuthModelState: PhoneAuthModelState.error);
    }
  }

  //Log in or sign up via credential
  Future<PhoneAuthModel> loginWithCredential({
    required AuthCredential credential,
  }) async {
    UserCredential userCredential = await firebaseProvider.loginWithCredential(
      credential: credential,
    );
    User? user = userCredential.user;
    if (user != null) {
      return PhoneAuthModel(
          phoneAuthModelState: PhoneAuthModelState.verified,
          uid: user.uid,
          isNewUser: userCredential.additionalUserInfo!.isNewUser);
    } else {
      return const PhoneAuthModel(
          phoneAuthModelState: PhoneAuthModelState.error);
    }
  }

  //Delete user
  Future<void> deleteCurrentUser() async {
    await firebaseProvider.deleteCurrentUser();
  }
}
