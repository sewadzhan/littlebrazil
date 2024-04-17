import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/order/order_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/cashback_bottom_sheet.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/data/models/order.dart';

class SuccessQRScannedScreen extends StatelessWidget {
  const SuccessQRScannedScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return SliverBody(
      title: "№${order.id}",
      bottomBar: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                color: Constants.backgroundColor,
                border: Border(
                    top:
                        BorderSide(color: Constants.lightGrayColor, width: 1))),
            padding: EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Обслуживание",
                        style: Constants.textTheme.headlineSmall,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${order.deliveryCost} ",
                            style: Constants.textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                  text: "₸",
                                  style: Constants.tengeStyle.copyWith(
                                      fontSize: Constants
                                          .textTheme.bodyLarge!.fontSize)),
                            ]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Итого",
                        style: Constants.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${order.total} ",
                            style: Constants.textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                  text: "₸",
                                  style: Constants.tengeStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants
                                          .textTheme.bodyLarge!.fontSize)),
                            ]),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  text: "ВЫБРАТЬ СПОСОБ ОПЛАТЫ",
                  function: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Constants.backgroundColor,
                        elevation: 0,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        builder: (context1) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<CheckoutBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<CashbackBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<OrderBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<CurrentUserBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<ContactsCubit>(),
                                ),
                              ],
                              child: CashbackBottomSheet(
                                subfinalValue: order.total,
                              ),
                            ));
                  },
                )
              ],
            )),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: order.cartItems.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: order.cartItems[index]
                                                  .orderModifiers.isEmpty
                                              ? Constants.defaultPadding * 0.5
                                              : 5),
                                      child: Column(
                                        children: [
                                          Text(
                                            order
                                                .cartItems[index].product.title,
                                            style:
                                                Constants.textTheme.titleLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: order.cartItems[index]
                                                  .orderModifiers.isEmpty
                                              ? 0
                                              : Constants.defaultPadding *
                                                  0.25),
                                      child: Column(
                                          children: List.generate(
                                              order.cartItems[index]
                                                  .orderModifiers.length,
                                              (modIndex) => Text(
                                                    "${order.cartItems[index].orderModifiers[modIndex].productGroupName}: ${order.cartItems[index].orderModifiers[modIndex].modifier.name}",
                                                    style: Constants
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            color: Constants
                                                                .middleGrayColor),
                                                  ))),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${order.cartItems[index].count}x",
                                          style: Constants.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Constants
                                                      .middleGrayColor),
                                        ),
                                        const SizedBox(width: 10),
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "${order.cartItems[index].product.price} ",
                                              style: Constants
                                                  .textTheme.titleLarge,
                                              children: [
                                                TextSpan(
                                                    text: "₸",
                                                    style: Constants.tengeStyle
                                                        .copyWith(
                                                            fontSize: Constants
                                                                .textTheme
                                                                .bodyMedium!
                                                                .fontSize)),
                                              ]),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Constants.lightGrayColor,
                              ),
                            ),
                          ],
                        )),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text("Дата заказа",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500))),
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding),
              child: Text(
                DateFormat('dd.MM.yyyy, kk:mm').format(order.dateTime),
                style: Constants.textTheme.bodyMedium,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text("Адрес заказа",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(order.fullAddress,
                    style: Constants.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
