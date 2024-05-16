import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/data/models/cashback_data.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/order/order_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/payment_bottom_sheet.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Cashback bottom sheet in Checkout Screen
class CashbackBottomSheet extends StatelessWidget {
  const CashbackBottomSheet({super.key, required this.subfinalValue});

  final int subfinalValue;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
    return BlocBuilder<CashbackBloc, CashbackState>(
      builder: (context, cashbackState) {
        return BlocBuilder<CheckoutBloc, Checkout>(
          builder: (context, checkoutState) {
            if (cashbackState is CashbackLoaded) {
              int cashbackValue =
                  cashbackState.getCashbackFromSum(subfinalValue);
              return SizedBox(
                height: cashbackState.cashbackData.cashbackAction ==
                            CashbackAction.deposit &&
                        cashbackValue != 0
                    ? 415
                    : 350,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      child: Container(
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
                                child: Text(appLocalization.payForTheOrder,
                                    style: Constants
                                        .headlineTextTheme.displayMedium!
                                        .copyWith(
                                      color: Constants.primaryColor,
                                    )),
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: SizedBox(
                                      width: 25,
                                      child: SvgPicture.asset(
                                          Config.getPaymentMethodIconPath(
                                              paymentMethod:
                                                  checkoutState.paymentMethod)),
                                    ),
                                    title: Text(
                                      Config.paymentMethodToTitleString(
                                          paymentMethod:
                                              checkoutState.paymentMethod,
                                          languageCode:
                                              currentLocale.languageCode),
                                      style: Constants.textTheme.bodyLarge!
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      Config.getPaymentMethodDescription(
                                          paymentMethod:
                                              checkoutState.paymentMethod,
                                          languageCode:
                                              currentLocale.languageCode),
                                      style: Constants.textTheme.bodyMedium!
                                          .copyWith(
                                              color: Constants.middleGrayColor),
                                    ),
                                    trailing: SvgPicture.asset(
                                        'assets/icons/arrow-right.svg',
                                        colorFilter: const ColorFilter.mode(
                                            Constants.middleGrayColor,
                                            BlendMode.srcIn)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              Constants.backgroundColor,
                                          elevation: 0,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                          ),
                                          builder: (context1) =>
                                              MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<CheckoutBloc>(),
                                                  ),
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<ContactsCubit>(),
                                                  ),
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<CashbackBloc>(),
                                                  ),
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<OrderBloc>(),
                                                  ),
                                                  BlocProvider.value(
                                                    value: context.read<
                                                        CurrentUserBloc>(),
                                                  ),
                                                ],
                                                child: PaymentBottomSheet(
                                                  subfinalValue: subfinalValue,
                                                ),
                                              ));
                                    },
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Constants.lightGrayColor,
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 1.5),
                                child: Column(
                                  children: [
                                    BlocBuilder<CurrentUserBloc,
                                        CurrentUserState>(
                                      builder: (context, currentUserState) {
                                        if (currentUserState
                                            is CurrentUserRetrieveSuccessful) {
                                          return SwitchListTile(
                                            value: cashbackState.cashbackData
                                                    .cashbackAction ==
                                                CashbackAction.withdraw,
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            activeColor: Constants.purpleColor,
                                            inactiveThumbColor:
                                                Constants.middleGrayColor,
                                            inactiveTrackColor:
                                                Constants.lightGrayColor,
                                            title: Text(
                                              appLocalization
                                                  .applyAccumulatedPoints,
                                              style: Constants
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            subtitle: Text(
                                              "${appLocalization.youHaveAccumulated} ${currentUserState.user.cashback} ${appLocalization.b}",
                                              style: Constants
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Constants
                                                          .middleGrayColor),
                                            ),
                                            onChanged: (value) {
                                              if (currentUserState
                                                      .user.cashback ==
                                                  0) {
                                                return;
                                              }
                                              if (value) {
                                                context.read<CashbackBloc>().add(
                                                    const CashbackActionChanged(
                                                        cashbackAction:
                                                            CashbackAction
                                                                .withdraw));
                                              } else {
                                                context.read<CashbackBloc>().add(
                                                    const CashbackActionChanged(
                                                        cashbackAction:
                                                            CashbackAction
                                                                .deposit));
                                              }
                                            },
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width,
                                      color: Constants.lightGrayColor,
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cashbackState
                                                .cashbackData.cashbackAction ==
                                            CashbackAction.deposit &&
                                        cashbackState.cashbackData.isEnabled &&
                                        cashbackValue != 0
                                    ? [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Constants.defaultPadding *
                                                      0.75,
                                              vertical:
                                                  Constants.defaultPadding *
                                                      0.6),
                                          margin: EdgeInsets.only(
                                              bottom: Constants.defaultPadding),
                                          decoration: const BoxDecoration(
                                              color: Constants.lightGreenColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                margin: EdgeInsets.only(
                                                    right: Constants
                                                        .defaultPadding),
                                                child: SvgPicture.asset(
                                                    'assets/icons/shooting-star.svg',
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Constants
                                                                .primaryColor,
                                                            BlendMode.srcIn)),
                                              ),
                                              Text(
                                                appLocalization
                                                    .youWillAccumulatePoints(
                                                        cashbackValue),
                                                style: Constants
                                                    .textTheme.headlineSmall!
                                                    .copyWith(
                                                        color: Constants
                                                            .primaryColor),
                                              )
                                            ],
                                          ),
                                        )
                                      ]
                                    : const [],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 0.3),
                                child: BlocBuilder<CurrentUserBloc,
                                    CurrentUserState>(
                                  builder: (context, currentUserState) {
                                    if (currentUserState
                                        is CurrentUserRetrieveSuccessful) {
                                      return BlocConsumer<OrderBloc,
                                          OrderState>(
                                        listener: (context, orderState) {
                                          if (orderState is OrderFailed) {
                                            var errorSnackBar =
                                                Constants.errorSnackBar(
                                                    context, orderState.message,
                                                    duration: const Duration(
                                                        milliseconds: 500));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(errorSnackBar);
                                          }
                                        },
                                        builder: (context, orderState) {
                                          return CustomElevatedButton(
                                              text:
                                                  "${appLocalization.pay} • ${cashbackState.cashbackData.cashbackAction == CashbackAction.deposit ? subfinalValue : subfinalValue - currentUserState.user.cashback}",
                                              isLoading:
                                                  orderState is OrderLoading,
                                              withTengeSign: true,
                                              function: () {
                                                var checkoutBloc = context
                                                    .read<CheckoutBloc>();
                                                context
                                                    .read<OrderBloc>()
                                                    .add(NewOrderPlaced(
                                                      checkout:
                                                          checkoutBloc.state,
                                                    ));
                                              });
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              )
                            ],
                          )),
                    )),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
