import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/data/models/cashback_data.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/payment_bottom_sheet.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Cashback bottom sheet in Checkout Screen
class CashbackBottomSheet extends StatelessWidget {
  const CashbackBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: BlocBuilder<CheckoutBloc, Checkout>(
            builder: (context, checkoutState) {
              return Container(
                  padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 2,
                      left: Constants.defaultPadding,
                      right: Constants.defaultPadding,
                      bottom: Constants.defaultPadding * 0.25),
                  child: BlocBuilder<CashbackBloc, CashbackState>(
                    builder: (context, state) {
                      if (state is CashbackLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding * 0.5),
                              child: Text("Оплатите заказ",
                                  style: Constants
                                      .headlineTextTheme.displayMedium!
                                      .copyWith(
                                    color: Constants.primaryColor,
                                  )),
                            ),
                            Column(
                              children: [
                                BlocBuilder<CheckoutBloc, Checkout>(
                                  builder: (context, state) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: SizedBox(
                                        width: 25,
                                        child: SvgPicture.asset(
                                            Config.getPaymentMethodIconPath(
                                                paymentMethod:
                                                    state.paymentMethod)),
                                      ),
                                      title: Text(
                                        Config.paymentMethodToString(
                                            paymentMethod: state.paymentMethod),
                                        style: Constants.textTheme.bodyLarge!
                                            .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        Config.getPaymentMethodDescription(
                                            paymentMethod: state.paymentMethod),
                                        style: Constants.textTheme.bodyMedium!
                                            .copyWith(
                                                color:
                                                    Constants.middleGrayColor),
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
                                              borderRadius:
                                                  BorderRadius.vertical(
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
                                                      value: context.read<
                                                          ContactsCubit>(),
                                                    ),
                                                    BlocProvider.value(
                                                      value: context
                                                          .read<CashbackBloc>(),
                                                    ),
                                                    BlocProvider.value(
                                                      value: context
                                                          .read<CartBloc>(),
                                                    ),
                                                  ],
                                                  child:
                                                      const PaymentBottomSheet(),
                                                ));
                                      },
                                    );
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
                                  BlocBuilder<CashbackBloc, CashbackState>(
                                    builder: (context, cashbackState) {
                                      if (cashbackState is CashbackLoaded) {
                                        return SwitchListTile(
                                          value: cashbackState.cashbackData
                                                  .cashbackAction ==
                                              CashbackAction.withdraw,
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor:
                                              Constants.secondPrimaryColor,
                                          inactiveThumbColor:
                                              Constants.middleGrayColor,
                                          inactiveTrackColor:
                                              Constants.lightGrayColor,
                                          title: Text(
                                            "Применить накопленные баллы",
                                            style: Constants
                                                .textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            "Вы накопили 3200 Б",
                                            style: Constants
                                                .textTheme.bodyMedium!
                                                .copyWith(
                                                    color: Constants
                                                        .middleGrayColor),
                                          ),
                                          onChanged: (value) {
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Constants.defaultPadding * 0.75,
                                  vertical: Constants.defaultPadding * 0.6),
                              margin: EdgeInsets.only(
                                  bottom: Constants.defaultPadding),
                              decoration: const BoxDecoration(
                                  color: Constants.lightGreenColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    margin: EdgeInsets.only(
                                        right: Constants.defaultPadding),
                                    child: SvgPicture.asset(
                                        'assets/icons/shooting-star.svg',
                                        colorFilter: const ColorFilter.mode(
                                            Constants.primaryColor,
                                            BlendMode.srcIn)),
                                  ),
                                  Text(
                                    "Вы накопите 1120 баллов",
                                    style: Constants.textTheme.headlineSmall!
                                        .copyWith(
                                            color: Constants.primaryColor),
                                  )
                                ],
                              ),
                            ),
                            BlocBuilder<CartBloc, CartState>(
                              builder: (context, cartState) {
                                if (cartState is CartLoaded) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Constants.defaultPadding * 0.3),
                                    child: CustomElevatedButton(
                                        text:
                                            "ОПЛАТИТЬ • ${cartState.cart.subtotal - cartState.cart.discount + checkoutState.deliveryCost} ₸",
                                        function: () {
                                          Navigator.pushNamed(
                                              context, '/addAddress');
                                        }),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            )
                          ],
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Constants.defaultPadding * 0.75),
                            child: const ShimmerListTile(),
                          ),
                        ),
                      );
                    },
                  ));
            },
          ),
        ),
      ],
    );
  }
}