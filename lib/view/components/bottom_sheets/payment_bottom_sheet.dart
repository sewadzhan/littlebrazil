import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/order/order_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/cashback_bottom_sheet.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Payment type bottom sheet
class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({super.key, required this.subfinalValue});

  final int subfinalValue;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
    return Wrap(
      children: [
        SafeArea(
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
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                    child: Text(appLocalization.choosePaymentMethod,
                        style:
                            Constants.headlineTextTheme.displayMedium!.copyWith(
                          color: Constants.primaryColor,
                        )),
                  ),
                  BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, contactState) {
                      if (contactState is ContactsLoadedState) {
                        var paymentMethods =
                            contactState.contactsModel.paymentMethods;
                        return Column(
                          children: [
                            // paymentMethods['cash'] != null &&
                            //         paymentMethods['cash']!
                            //     ? ListTile(
                            //         onTap: () {
                            //           context.read<CheckoutBloc>().add(
                            //               const CheckoutPaymentMethodChanged(
                            //                   PaymentMethod.cash));
                            //           Navigator.pop(context);
                            //         },
                            //         contentPadding: EdgeInsets.symmetric(
                            //             horizontal:
                            //                 Constants.defaultPadding * 0.5),
                            //         leading: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.end,
                            //           children: [
                            //             SizedBox(
                            //               width: 30,
                            //               height: 30,
                            //               child: SvgPicture.asset(
                            //                   'assets/icons/cash.svg',
                            //                   colorFilter:
                            //                       const ColorFilter.mode(
                            //                           Constants
                            //                               .darkGrayColor,
                            //                           BlendMode.srcIn)),
                            //             ),
                            //           ],
                            //         ),
                            //         title: Text(
                            //           Config.paymentMethodToString(
                            //               paymentMethod:
                            //                   PaymentMethod.cash),
                            //           style: Constants.textTheme.bodyLarge,
                            //         ),
                            //         trailing: SvgPicture.asset(
                            //             'assets/icons/arrow_right.svg',
                            //             ),
                            //       )
                            //     : const SizedBox.shrink(),
                            // paymentMethods['nonCash'] != null &&
                            //         paymentMethods['nonCash']!
                            //     ? ListTile(
                            //         onTap: () {
                            //           context.read<CheckoutBloc>().add(
                            //               const CheckoutPaymentMethodChanged(
                            //                   PaymentMethod.nonCash));
                            //           Navigator.pop(context);
                            //         },
                            //         contentPadding: EdgeInsets.symmetric(
                            //             horizontal:
                            //                 Constants.defaultPadding * 0.5),
                            //         leading: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.end,
                            //           children: [
                            //             SizedBox(
                            //               width: 30,
                            //               height: 30,
                            //               child: SvgPicture.asset(
                            //                   'assets/icons/non_cash.svg',
                            //                   colorFilter:
                            //                       const ColorFilter.mode(
                            //                           Constants
                            //                               .darkGrayColor,
                            //                           BlendMode.srcIn)),
                            //             ),
                            //           ],
                            //         ),
                            //         title: Text(
                            //           Config.paymentMethodToString(
                            //               paymentMethod:
                            //                   PaymentMethod.nonCash),
                            //           style: Constants.textTheme.bodyLarge,
                            //         ),
                            //         trailing: SvgPicture.asset(
                            //             'assets/icons/arrow_right.svg',
                            //             ),
                            //       )
                            // : const SizedBox.shrink(),
                            paymentMethods['bankCard'] != null &&
                                    paymentMethods['bankCard']!
                                ? Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                  'assets/icons/card.svg',
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Constants
                                                              .darkGrayColor,
                                                          BlendMode.srcIn)),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          Config.paymentMethodToTitleString(
                                              paymentMethod:
                                                  PaymentMethod.bankCard,
                                              languageCode:
                                                  currentLocale.languageCode),
                                          style: Constants.textTheme.bodyLarge,
                                        ),
                                        trailing: SvgPicture.asset(
                                          'assets/icons/arrow-right.svg',
                                        ),
                                        onTap: () {
                                          context.read<CheckoutBloc>().add(
                                              const CheckoutPaymentMethodChanged(
                                                  PaymentMethod.bankCard));

                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Constants.backgroundColor,
                                              elevation: 0,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12)),
                                              ),
                                              builder: (context1) =>
                                                  MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CheckoutBloc>(),
                                                      ),
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            ContactsCubit>(),
                                                      ),
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CashbackBloc>(),
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
                                                    child: CashbackBottomSheet(
                                                      subfinalValue:
                                                          subfinalValue,
                                                    ),
                                                  ));
                                        },
                                      ),
                                      Container(
                                        height: 1,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Constants.lightGrayColor,
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            paymentMethods['kaspi'] != null &&
                                    paymentMethods['kaspi']!
                                ? Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                'assets/icons/kaspi.svg',
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          Config.paymentMethodToTitleString(
                                              paymentMethod:
                                                  PaymentMethod.kaspi,
                                              languageCode:
                                                  currentLocale.languageCode),
                                          style: Constants.textTheme.bodyLarge,
                                        ),
                                        trailing: SvgPicture.asset(
                                          'assets/icons/arrow-right.svg',
                                        ),
                                        onTap: () {
                                          context.read<CheckoutBloc>().add(
                                              const CheckoutPaymentMethodChanged(
                                                  PaymentMethod.kaspi));

                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Constants.backgroundColor,
                                              elevation: 0,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12)),
                                              ),
                                              builder: (context1) =>
                                                  MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CheckoutBloc>(),
                                                      ),
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            ContactsCubit>(),
                                                      ),
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CashbackBloc>(),
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
                                                    child: CashbackBottomSheet(
                                                      subfinalValue:
                                                          subfinalValue,
                                                    ),
                                                  ));
                                        },
                                      ),
                                      Container(
                                        height: 1,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Constants.lightGrayColor,
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
