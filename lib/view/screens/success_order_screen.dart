import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:littlebrazil/logic/cubits/rate_app/rate_app_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SuccessOrderScreen extends StatelessWidget {
  final Order order;

  const SuccessOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SliverBody(
      showBackButton: false,
      title: "Ваш заказ принят!",
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
                      Text(
                        "${order.discount} ₸",
                        style: Constants.textTheme.headlineSmall,
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
                      Text(
                        "${order.deliveryCost} ₸",
                        style: Constants.textTheme.headlineSmall,
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
                      Text(
                        "${order.total} ₸",
                        style: Constants.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                    text: "На главную",
                    function: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);

                      //Call rate app popup
                      context.read<RateAppCubit>().showRateAppPopup(context);
                    }),
              ],
            )),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
              vertical: Constants.defaultPadding),
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                child: RichText(
                    text: TextSpan(
                        text: "Ваш заказ с номером ",
                        style: Constants.textTheme.bodyLarge,
                        children: [
                      TextSpan(
                          text: "№${order.id} ",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text:
                              "принят! Заказ будет доставлен в течение 90-110 минут")
                    ])),
              ),
              Column(
                  children: order.cartItems
                      .map((e) => Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 67,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        image: e.product.imageUrls.isNotEmpty
                                            ? DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(e
                                                        .product
                                                        .imageUrls
                                                        .first),
                                                fit: BoxFit.cover)
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    'assets/decorations/no_image_url.png'),
                                                fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                      width: Constants.defaultPadding * 0.5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: e.orderModifiers.isEmpty
                                                ? Constants.defaultPadding * 0.5
                                                : 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              e.product.title,
                                              style: Constants
                                                  .textTheme.titleLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: e.orderModifiers.isEmpty
                                                ? 0
                                                : Constants.defaultPadding *
                                                    0.25),
                                        child: Column(
                                            children: List.generate(
                                                e.orderModifiers.length,
                                                (index) => Text(
                                                      "${e.orderModifiers[index].productGroupName}: ${e.orderModifiers[index].modifier.name}",
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
                                            "${e.count}x",
                                            style: Constants
                                                .textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Constants
                                                        .middleGrayColor),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "${e.product.price} ₸",
                                            style:
                                                Constants.textTheme.titleLarge,
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
                          ))
                      .toList())
            ],
          )),
    );
  }
}
