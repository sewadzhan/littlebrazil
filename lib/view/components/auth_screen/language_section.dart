import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';

import 'package:littlebrazil/view/config/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginLanguageSection extends StatefulWidget {
  const LoginLanguageSection({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<LoginLanguageSection> createState() => _LoginLanguageSectionState();
}

class _LoginLanguageSectionState extends State<LoginLanguageSection> {
  Locale? selectedLocale;

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
              child: SvgPicture.asset(
                'assets/icons/cross.svg',
              ),
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
                appLocalization.selectLanguage,
                style: Constants.headlineTextTheme.displayLarge!
                    .copyWith(color: Constants.blackColor),
              ),
            ),
            Column(
              children: [
                RadioListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: const Locale('kk'),
                  groupValue: selectedLocale,
                  activeColor: Constants.secondPrimaryColor,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      setState(() {
                        selectedLocale = value;
                      });
                    }
                  },
                  title: Text(
                    "Қазақша",
                    style: Constants.textTheme.headlineSmall,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Constants.lightGrayColor,
                )
              ],
            ),
            Column(
              children: [
                RadioListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: const Locale('ru'),
                  groupValue: selectedLocale,
                  activeColor: Constants.secondPrimaryColor,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      setState(() {
                        selectedLocale = value;
                      });
                    }
                  },
                  title: Text(
                    "Русский",
                    style: Constants.textTheme.headlineSmall,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Constants.lightGrayColor,
                )
              ],
            ),
            Column(
              children: [
                RadioListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: const Locale('en'),
                  groupValue: selectedLocale,
                  activeColor: Constants.secondPrimaryColor,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      setState(() {
                        selectedLocale = value;
                      });
                    }
                  },
                  title: Text(
                    "English",
                    style: Constants.textTheme.headlineSmall,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Constants.lightGrayColor,
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
              child: CustomElevatedButton(
                  text: appLocalization.select,
                  function: () async {
                    if (selectedLocale == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.errorSnackBar(
                              context, appLocalization.selectLanguage));
                    }
                    context
                        .read<LocalizationCubit>()
                        .setLocale(selectedLocale!);
                    await widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  }),
            )
          ],
        )
      ]),
    );
  }

  void launchURL(Uri url) async => await canLaunchUrl(url)
      ? await launchUrl(url)
      : throw 'Could not launch $url';
}
