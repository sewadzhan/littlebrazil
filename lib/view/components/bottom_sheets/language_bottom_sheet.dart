import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Language changing bottom sheet
class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key, required this.initialLocale});

  final Locale initialLocale;

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late Locale selectedLocale;

  @override
  void initState() {
    selectedLocale = widget.initialLocale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 2,
                    left: Constants.defaultPadding,
                    right: Constants.defaultPadding,
                    bottom: Constants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text("Выберите язык",
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(
                            color: Constants.primaryColor,
                          )),
                    ),
                    Column(
                      children: [
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          value: const Locale('kz'),
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
                    Padding(
                      padding: EdgeInsets.only(top: Constants.defaultPadding),
                      child: CustomElevatedButton(
                          text: "СОХРАНИТЬ",
                          function: () {
                            context
                                .read<LocalizationCubit>()
                                .setLocale(selectedLocale);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                Constants.successSnackBar(
                                    context, "Настройки языка сохранены"));
                          }),
                    )
                  ],
                ))),
      ],
    );
  }
}
