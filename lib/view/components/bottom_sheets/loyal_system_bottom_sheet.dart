import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Loyal System info bottom sheet
class LoyalSystemBottomSheet extends StatelessWidget {
  const LoyalSystemBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
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
                      child: Text(appLocalization.loyaltySystem,
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(
                            color: Constants.primaryColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        appLocalization.earnPointsGetDiscounts,
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "${appLocalization.howItWorks}\n${appLocalization.orderPoints}\n${appLocalization.orderAmountPoints}\n${appLocalization.redeemPoints}",
                        style: Constants.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        appLocalization.howToUsePoints,
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "${appLocalization.onePointOneTenge}\n${appLocalization.payWithPoints}\n${appLocalization.pointsDoNotExpire}",
                        style: Constants.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        appLocalization.bonusPointsAccumulation,
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    BlocBuilder<CashbackBloc, CashbackState>(
                      builder: (context, state) {
                        if (state is CashbackLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                state.cashbackData.gradations.length,
                                (index) => Text(
                                      appLocalization.overNTenge(
                                          state.cashbackData.gradations[index]
                                              .bound,
                                          state.cashbackData.gradations[index]
                                              .percent),
                                      style: Constants.textTheme.bodyMedium,
                                    )),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ))),
      ],
    );
  }
}
