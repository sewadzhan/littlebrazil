import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/data/models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

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
                        "Скидка",
                        style: Constants.textTheme.headlineSmall,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${order.discount} ",
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
                        "Доставка",
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
                getCashbackBar(order)
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
              child: Text(
                DateFormat('dd.MM.yyyy, kk:mm').format(order.dateTime),
                style: Constants.textTheme.bodyLarge,
              ),
            ),
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
                                // Container(
                                //   width: 67,
                                //   height: 40,
                                //   decoration: const BoxDecoration(
                                //       borderRadius:
                                //           BorderRadius.all(Radius.circular(4)),
                                //       image: DecorationImage(
                                //           image: NetworkImage(
                                //               'https://pikapika.kz/wp-content/uploads/2021/08/%D0%A7%D1%83%D0%BA%D0%B0-%D1%80%D0%BE%D0%BB%D0%BB.jpg'),
                                //           fit: BoxFit.cover)),
                                // ),
                                // const SizedBox(
                                //     width: Constants.defaultPadding * 0.5),
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
                child: Text("Способ получения",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(Config.orderTypeToString(order.orderType),
                    style: Constants.textTheme.bodyMedium)),
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
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text("Способ оплаты",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                    Config.paymentMethodToString(
                        paymentMethod: order.paymentMethod),
                    style: Constants.textTheme.bodyMedium)),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text("Комментарии",
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                    order.comments.trim().isEmpty
                        ? "Комментариев нет"
                        : order.comments,
                    style: Constants.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }

  getCashbackBar(Order order) {
    if (order.cashbackUsed != 0) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding * 0.75,
            vertical: Constants.defaultPadding * 0.6),
        decoration: BoxDecoration(
            color: order.cashbackUsed > 0
                ? Constants.lightGreenColor
                : Constants.lightPurpleColor,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Row(
          children: [
            Container(
              width: 30,
              margin: EdgeInsets.only(right: Constants.defaultPadding),
              child: SvgPicture.asset('assets/icons/shooting-star.svg',
                  colorFilter: ColorFilter.mode(
                      order.cashbackUsed > 0
                          ? Constants.primaryColor
                          : Constants.purpleColor,
                      BlendMode.srcIn)),
            ),
            Text(
              order.cashbackUsed > 0
                  ? "Вы накопили ${order.cashbackUsed} баллов"
                  : "Вы применили ${order.cashbackUsed * -1} баллов",
              style: Constants.textTheme.headlineSmall!.copyWith(
                  color: order.cashbackUsed > 0
                      ? Constants.primaryColor
                      : Constants.purpleColor),
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
