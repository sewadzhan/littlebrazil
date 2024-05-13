import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/otp_section/otp_section_cubit.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPSection extends StatelessWidget {
  const OTPSection({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final appLocalization = AppLocalizations.of(context)!;

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
            onPressed: () async {
              context.read<OTPSectionCubit>().setToInitialState();
              context.read<PhoneAuthBloc>().add(PhoneAuthReset());
              await pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
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
                    appLocalization.enterSmsCode,
                    style: Constants.headlineTextTheme.displayLarge!
                        .copyWith(color: Constants.blackColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding * 3),
              child: BlocBuilder<OTPSectionCubit, OTPSectionState>(
                builder: (context, otpSectionState) {
                  if (otpSectionState is OTPSentState) {
                    return RichText(
                      text: TextSpan(
                          text:
                              "${appLocalization.confirmationCodeSentToNumber} ",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(height: 1.35),
                          children: [
                            TextSpan(
                              text: otpSectionState.phoneNumber,
                              style: Constants.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          ]),
                      textAlign: TextAlign.start,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            SizedBox(
              width: 320,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding * 2,
                ),
                child: BlocBuilder<OTPSectionCubit, OTPSectionState>(
                  builder: (context, otpSectionState) {
                    if (otpSectionState is OTPSentState) {
                      return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
                        listener: (context, phoneAuthState) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          if (phoneAuthState
                              is PhoneAuthCodeVerificationSuccess) {
                            context.read<OTPSectionCubit>().setToInitialState();
                            if (phoneAuthState.isNewUser) {
                              context.read<PhoneAuthBloc>().add(
                                  CreateNewUserInFirestore(
                                      phoneNumber: otpSectionState.phoneNumber,
                                      name: otpSectionState.name,
                                      welcomeBonus:
                                          checkWelcomeBonus(context)));
                            } else {
                              context.read<AuthCubit>().getCurrentUser();
                              Navigator.of(context).pop();
                              //successful log in
                            }
                          } else if (phoneAuthState
                              is PhoneAuthCreateUserSuccess) {
                            context.read<AuthCubit>().getCurrentUser();
                            context.read<CurrentUserBloc>().isNewUser = true;
                            Navigator.of(context).pop();
                            //successful log in of new user
                          } else if (phoneAuthState
                              is PhoneAuthCodeVerificationFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                Constants.errorSnackBar(
                                    context, phoneAuthState.message));
                          } else if (phoneAuthState
                              is PhoneAuthCodeAutoRetrevalTimeoutComplete) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                Constants.errorSnackBar(context,
                                    appLocalization.smsCodeRecoveryTimeout,
                                    duration: const Duration(days: 1)));
                          }
                        },
                        builder: (context, phoneAuthState) {
                          return PinCodeTextField(
                            controller: otpController,
                            autovalidateMode: AutovalidateMode.disabled,
                            length: 6,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: false),
                            animationType: AnimationType.fade,
                            showCursor: false,
                            autoFocus: false,
                            animationDuration:
                                const Duration(milliseconds: 300),
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
                              if (phoneAuthState
                                  is PhoneAuthNumberVerificationSuccess) {
                                context.read<PhoneAuthBloc>().add(
                                    PhoneAuthCodeVerified(
                                        verificationId:
                                            phoneAuthState.verificationId,
                                        smsCode: smsOTP,
                                        resendToken:
                                            phoneAuthState.resendToken));
                              } else if (phoneAuthState
                                  is PhoneAuthNumberVerificationResendSuccess) {
                                context.read<PhoneAuthBloc>().add(
                                    PhoneAuthCodeVerified(
                                        verificationId:
                                            phoneAuthState.verificationId,
                                        smsCode: smsOTP,
                                        resendToken:
                                            phoneAuthState.resendToken));
                              } else if (phoneAuthState
                                  is PhoneAuthCodeVerificationFailure) {
                                context.read<PhoneAuthBloc>().add(
                                    PhoneAuthCodeVerified(
                                        verificationId:
                                            phoneAuthState.verificationId,
                                        smsCode: smsOTP,
                                        resendToken:
                                            phoneAuthState.resendToken));
                              }
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
              builder: (context, phoneAuthState) {
                return BlocBuilder<OTPSectionCubit, OTPSectionState>(
                  builder: (context, otpSectionState) {
                    if (otpSectionState is ResendSMSTimerStarted) {
                      return Text(
                          "${appLocalization.youCanSendTheCodeAgainIn} ${otpSectionState.seconds}",
                          style: Constants.textTheme.bodyLarge);
                    } else if (otpSectionState is OTPSentState) {
                      return RichText(
                          text: TextSpan(
                              text: "${appLocalization.didNotReceiveCode} ",
                              style: Constants.textTheme.bodyLarge,
                              children: [
                            TextSpan(
                              text: appLocalization.sendAgain,
                              style: Constants.textTheme.bodyLarge!.copyWith(
                                  color: Constants.secondPrimaryColor,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context
                                      .read<OTPSectionCubit>()
                                      .startResendTimer();
                                  if (phoneAuthState
                                      is PhoneAuthNumberVerificationSuccess) {
                                    context.read<PhoneAuthBloc>().add(
                                        PhoneAuthNumberVerified(
                                            phoneNumber:
                                                otpSectionState.phoneNumber,
                                            resendToken:
                                                phoneAuthState.resendToken));
                                  } else if (phoneAuthState
                                      is PhoneAuthCodeVerificationFailure) {
                                    context.read<PhoneAuthBloc>().add(
                                        PhoneAuthNumberVerified(
                                            phoneNumber:
                                                otpSectionState.phoneNumber,
                                            resendToken:
                                                phoneAuthState.resendToken));
                                  } else if (phoneAuthState
                                      is PhoneAuthCodeAutoRetrevalTimeoutComplete) {
                                    context
                                        .read<PhoneAuthBloc>()
                                        .add(PhoneAuthNumberVerified(
                                          phoneNumber:
                                              otpSectionState.phoneNumber,
                                        ));
                                  }
                                },
                            ),
                          ]));
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            )
          ],
        )
      ]),
    );
  }

  int? checkWelcomeBonus(BuildContext context) {
    var cashbackBlocState = context.read<CashbackBloc>().state;
    if (cashbackBlocState is CashbackLoaded) {
      return cashbackBlocState.cashbackData.isWelcomeBonusEnabled
          ? cashbackBlocState.cashbackData.welcomeBonus
          : null;
    }
    return null;
  }
}
