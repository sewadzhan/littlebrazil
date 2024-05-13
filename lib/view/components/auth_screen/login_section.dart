import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:littlebrazil/logic/cubits/otp_section/otp_section_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController nameController = TextEditingController();
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 ### ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SvgPicture.asset('assets/icons/cross.svg',
                  colorFilter: const ColorFilter.mode(
                      Constants.darkGrayColor, BlendMode.srcIn)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Constants.defaultPadding * 1.5,
                bottom: Constants.defaultPadding * 1.5,
              ),
              child: Text(
                "OLÁ, AMIGO 👋",
                style: Constants.headlineTextTheme.displayLarge!
                    .copyWith(color: Constants.blackColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding),
              child: Text(
                appLocalization.enterNameAndPhoneForAuthorization,
                style: Constants.textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding),
              child: CustomTextInputField(
                controller: nameController,
                hintText: appLocalization.mark,
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding),
              child: CustomTextInputField(
                  hintText: "+7",
                  inputFormatters: [maskFormatter],
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true)),
            ),
            BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
              listener: (context, state) async {
                if (state is PhoneAuthNumberVerificationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.errorSnackBar(context, state.message,
                          duration: const Duration(milliseconds: 500)));
                } else if (state is PhoneAuthNumberVerificationSuccess) {
                  context.read<OTPSectionCubit>().startResendTimer();
                  await widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                }
              },
              builder: (context, phoneAuthState) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                  child: CustomElevatedButton(
                      text: appLocalization.login,
                      isLoading: phoneAuthState is PhoneAuthLoading,
                      isEnabled: phoneAuthState
                          is! PhoneAuthLoading, //&& loginCheckBoxState
                      function: () {
                        if (nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.errorSnackBar(
                                  context, appLocalization.fillInName));
                          return;
                        }
                        context.read<OTPSectionCubit>().saveOTPData(
                            name: nameController.text,
                            phoneNumber: maskFormatter.getMaskedText());
                        context.read<PhoneAuthBloc>().add(
                            PhoneAuthNumberVerified(
                                phoneNumber: maskFormatter.getMaskedText()));
                      }),
                );
              },
            ),
            RichText(
                text: TextSpan(
                    text: appLocalization.byRegisteringYouAgreeTo,
                    style: Constants.textTheme.bodyMedium,
                    children: [
                  TextSpan(
                    text: appLocalization.privacyPolicy,
                    style: Constants.textTheme.bodyMedium!
                        .copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.https('littlebrazil.kz'));
                      },
                  ),
                  TextSpan(
                      text: appLocalization.littleBrazilRestaurant,
                      style: Constants.textTheme.bodyMedium)
                ]))
          ],
        )
      ]),
    );
  }

  void launchURL(Uri url) async => await canLaunchUrl(url)
      ? await launchUrl(url)
      : throw 'Could not launch $url';
}
