import 'package:flutter/material.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Language changing bottom sheet
class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

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
                    bottom: Constants.defaultPadding * 0.25),
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
                          value: false,
                          groupValue: false,
                          activeColor: Constants.secondPrimaryColor,
                          onChanged: (value) {},
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
                          value: false,
                          groupValue: false,
                          activeColor: Constants.secondPrimaryColor,
                          onChanged: (value) {},
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
                          value: false,
                          groupValue: false,
                          activeColor: Constants.secondPrimaryColor,
                          onChanged: (value) {},
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
                          text: "СОХРАНИТЬ", function: () {}),
                    )
                  ],
                ))),
      ],
    );
  }
}
