import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/list_tiles/cart_item_list_tile.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
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
                        appLocalization.discount,
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
                        appLocalization.delivery,
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
                        appLocalization.total,
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
                getCashbackBar(order, appLocalization)
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
                    itemBuilder: (context, index) =>
                        CartItemListTile(cartItem: order.cartItems[index])),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text(appLocalization.orderDate,
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.darkGrayColor,
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
                child: Text(appLocalization.methodOfReceipt,
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.darkGrayColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                    Config.orderTypeToTitleString(
                        order.orderType, currentLocale.languageCode),
                    style: Constants.textTheme.bodyMedium)),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text(appLocalization.deliveryAddress,
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.darkGrayColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(order.fullAddress,
                    style: Constants.textTheme.bodyMedium)),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text(appLocalization.paymentMethod,
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.darkGrayColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                    Config.paymentMethodToTitleString(
                        paymentMethod: order.paymentMethod,
                        languageCode: currentLocale.languageCode),
                    style: Constants.textTheme.bodyMedium)),
            Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
                child: Text(appLocalization.comments,
                    style: Constants.textTheme.bodyLarge!.copyWith(
                        color: Constants.darkGrayColor,
                        fontWeight: FontWeight.w500))),
            Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                    order.comments.trim().isEmpty
                        ? appLocalization.noComments
                        : order.comments,
                    style: Constants.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }

  getCashbackBar(Order order, AppLocalizations appLocalizations) {
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
                          ? Constants.darkGrayColor
                          : Constants.purpleColor,
                      BlendMode.srcIn)),
            ),
            Text(
              order.cashbackUsed > 0
                  ? appLocalizations
                      .youHaveAccumulatedPoints(order.cashbackUsed)
                  : appLocalizations.youAppliedPoints(order.cashbackUsed * -1),
              style: Constants.textTheme.headlineSmall!.copyWith(
                  color: order.cashbackUsed > 0
                      ? Constants.darkGrayColor
                      : Constants.purpleColor),
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
