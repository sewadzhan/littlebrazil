import 'package:littlebrazil/data/providers/functions_provider.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';

class FunctionsRepositoty {
  final FunctionsProvider functionsProvider;

  FunctionsRepositoty(this.functionsProvider);

  Future<String?> sendVerificationCode({
    required String phone,
  }) async {
    try {
      final response = await functionsProvider.sendVerificationCode(
        phone: phone,
      );

      return response['uid'];
    } catch (e) {
      throw RestaurantException('Error sending verification code: $e');
    }
  }

  Future<String?> verifyOTP(
      {required String phone,
      required String smsCode,
      required String verificationId}) async {
    final response = await functionsProvider.verifyOTP(
        otp: smsCode, uid: verificationId, phone: phone);

    return response['customToken'];
  }
}
