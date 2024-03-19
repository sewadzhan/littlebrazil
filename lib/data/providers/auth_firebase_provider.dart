import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseProvider {
  final FirebaseAuth firebaseAuth;

  AuthFirebaseProvider(this.firebaseAuth) {
    firebaseAuth.setLanguageCode("ru");
  }

  //Get current user
  Future<User?> getUser() async {
    var user = firebaseAuth.currentUser;
    return user;
  }

  //Log out from account
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  //Checking user is logged in or not
  Future<bool> isSignedIn() async {
    var currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  //Sending SMS OTP to verify phone number
  Future<void> verifyPhoneNumber({
    required String mobileNumber,
    required onVerificationCompleted,
    required onVerificaitonFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificaitonFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeOut,
      timeout: const Duration(seconds: 120),
    );
  }

  //Resending SMS OTP to verify phone number
  Future<void> resendOTP(
      {required String mobileNumber,
      required onVerificationCompleted,
      required onVerificaitonFailed,
      required onCodeSent,
      required onCodeAutoRetrievalTimeOut,
      required resendToken}) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      forceResendingToken: resendToken,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificaitonFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeOut,
      timeout: const Duration(seconds: 120),
    );
  }

  //Log in or sign up via phone number after checking SMS OTP
  Future<UserCredential> loginWithSMSVerificationCode(
      {required String verificationId, required String smsCode}) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  //Log in or sign up via credential
  Future<UserCredential> loginWithCredential(
      {required AuthCredential credential}) async {
    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  //Delete user
  Future<void> deleteCurrentUser() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.currentUser!.delete();
    }
  }
}
