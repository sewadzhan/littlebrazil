import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key, required this.product, this.isShownInSearchScreen = false});

  final Product product;
  final bool isShownInSearchScreen;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
    return Container(
      margin: EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/productDetails',
                      arguments: product);
                },
                child: Container(
                  width: Constants.defaultPadding * 10,
                  height: Constants.defaultPadding * 8.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                        child: product.imageUrls.isEmpty ||
                                product.imageUrls.first.isEmpty
                            ? Image.asset('assets/decorations/no_image_url.png',
                                fit: BoxFit.cover)
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: product.imageUrls.first,
                              ),
                      ),
                      product.tag != ProductTags.none
                          ? Positioned(
                              top: Constants.defaultPadding * 0.4,
                              left: Constants.defaultPadding * 0.4,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 7, bottom: 4),
                                decoration: BoxDecoration(
                                    color: Config.getTagColor(product.tag),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Config.getTagTitle(product.tag,
                                        currentLocale.languageCode),
                                    textAlign: TextAlign.center,
                                    style: Constants
                                        .headlineTextTheme.headlineSmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            height: 0.8),
                                  ),
                                ),
                              ))
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: Constants.defaultPadding * 0.75,
                ),
                height: Constants.defaultPadding * 8.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width -
                          12.75 *
                              Constants
                                  .defaultPadding, //Calculated accounting for paddings and other stuff
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.125),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Constants.textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Constants.blackColor,
                                height: 1.15),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "${product.price}",
                                style: Constants.textTheme.bodySmall!.copyWith(
                                    color: Constants.darkGrayColor,
                                    height: 1.75),
                                children: [
                                  TextSpan(
                                      text: "₸", style: Constants.tengeStyle),
                                  TextSpan(
                                      text: " • 590 ${appLocalization.kcal}",
                                      style: Constants.textTheme.bodySmall!
                                          .copyWith(
                                              color: Constants.darkGrayColor,
                                              height: 1.75))
                                ]),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        width: Constants.defaultPadding * 8.5,
                        child: OutlinedButton(
                            onPressed: () {
                              // List<OrderModifier> modifiers = [];
                              // for (var e in product.groupModifiers) {
                              //   if (e.childModifiers.isNotEmpty) {
                              //     modifiers.add(OrderModifier(
                              //         modifier: e.childModifiers.first,
                              //         amount: 1,
                              //         productGroupId: e.id,
                              //         productGroupName: e.name));
                              //   }
                              // }
                              context.read<CartBloc>().add(CartItemAdded(
                                  CartItemModel(
                                      product: product,
                                      count: 1,
                                      orderModifiers: const [])));

                              if (isShownInSearchScreen) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Constants.successSnackBar(context,
                                        appLocalization.itemAddedToCart));
                              }
                            },
                            style: OutlinedButton.styleFrom(
                                overlayColor: Constants.secondPrimaryColor,
                                backgroundColor: Constants.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: const BorderSide(
                                    width: 1,
                                    color: Constants.secondPrimaryColor)),
                            child: Text(appLocalization.addToCart.toUpperCase(),
                                style: Constants
                                    .headlineTextTheme.headlineSmall!
                                    .copyWith(
                                        color: Constants.secondPrimaryColor))))
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: Constants.defaultPadding * 0.5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Constants.lightGrayColor,
            ),
          )
        ],
      ),
    );
  }
}
