import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPSection extends StatelessWidget {
  const OTPSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      child: Stack(children: [
        Positioned(
          right: Constants.defaultPadding * -0.75,
          top: 0,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: SizedBox(
              width: 25,
              child: SvgPicture.asset('assets/icons/arrow-left.svg',
                  colorFilter: const ColorFilter.mode(
                      Constants.darkGrayColor, BlendMode.srcIn)),
            ),
            onPressed: () {
              // context.read<PhoneAuthBloc>().add(PhoneAuthReset());
              //return back
            },
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Constants.defaultPadding * 1.5,
                  bottom: Constants.defaultPadding * 2),
              child: Row(
                children: [
                  Text(
                    "Введите SMS код",
                    style: Constants.headlineTextTheme.displayLarge!
                        .copyWith(color: Constants.blackColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding * 3),
              child: RichText(
                text: TextSpan(
                    text: "Код подтверждения был отправлен на номер ",
                    style:
                        Constants.textTheme.bodyLarge!.copyWith(height: 1.35),
                    children: [
                      TextSpan(
                        text: "+7 707 123 45 56",
                        style: Constants.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      )
                    ]),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 320,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding * 2,
                ),
                child: PinCodeTextField(
                  controller: otpController,
                  autovalidateMode: AutovalidateMode.disabled,
                  length: 6,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: false),
                  animationType: AnimationType.fade,
                  showCursor: false,
                  autoFocus: false,
                  animationDuration: const Duration(milliseconds: 300),
                  appContext: context,
                  pinTheme: PinTheme(
                    disabledColor: Constants.lightGrayColor,
                    inactiveColor: Constants.lightGrayColor,
                    selectedColor: Constants.thirdPrimaryColor,
                    activeColor: Constants.thirdPrimaryColor,
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                  onChanged: (value) {},
                  onCompleted: (smsOTP) {
                    // if (state
                    //     is PhoneAuthNumberVerificationSuccess) {
                    //   context.read<PhoneAuthBloc>().add(
                    //       PhoneAuthCodeVerified(
                    //           verificationId:
                    //               state.verificationId,
                    //           smsCode: smsOTP,
                    //           resendToken: state.resendToken));
                    // } else if (state
                    //     is PhoneAuthNumberVerificationResendSuccess) {
                    //   context.read<PhoneAuthBloc>().add(
                    //       PhoneAuthCodeVerified(
                    //           verificationId:
                    //               state.verificationId,
                    //           smsCode: smsOTP,
                    //           resendToken: state.resendToken));
                    // } else if (state
                    //     is PhoneAuthCodeVerificationFailure) {
                    //   context.read<PhoneAuthBloc>().add(
                    //       PhoneAuthCodeVerified(
                    //           verificationId:
                    //               state.verificationId,
                    //           smsCode: smsOTP,
                    //           resendToken: state.resendToken));
                    // }
                  },
                ),
              ),
            ),
            RichText(
                text: TextSpan(
                    text: "Не получили код? ",
                    style: Constants.textTheme.bodyLarge,
                    children: [
                  TextSpan(
                    text: "Отправить еще раз (59)",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.secondPrimaryColor,
                        fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //resend the code
                      },
                  ),
                ]))
          ],
        )
      ]),
    );
  }
}
