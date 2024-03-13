import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Loyal System info bottom sheet
class LoyalSystemBottomSheet extends StatelessWidget {
  const LoyalSystemBottomSheet({Key? key}) : super(key: key);

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
                      child: Text("Система лояльности",
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(
                            color: Constants.primaryColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "Накапливайте баллы и получайте скидки!",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "Накапливайте баллы и получайте скидки!",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))),
      ],
    );
  }
}
