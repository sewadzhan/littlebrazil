import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExtraSalesBottomSheet extends StatefulWidget {
  const ExtraSalesBottomSheet({
    super.key,
  });

  @override
  State<ExtraSalesBottomSheet> createState() => _ExtraSalesBottomSheetState();
}

class _ExtraSalesBottomSheetState extends State<ExtraSalesBottomSheet> {
  String buttonText = "";

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    var crossCategories = (context.read<MenuCubit>().state as MenuLoadedState)
        .categories
        .where((element) => element.type == CategoryType.extraSales);
    var extraSalesCategory = crossCategories.isNotEmpty
        ? crossCategories.first
        : const Category(
            type: CategoryType.extraSales,
            name: "Cross Sales",
            products: [],
            categoryID: "");
    if (buttonText.isEmpty) {
      buttonText = appLocalization.noThanks;
    }

    return SafeArea(
      child: SizedBox(
        height: Constants.defaultPadding * 26.5,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: Constants.defaultPadding * 2,
                  bottom: Constants.defaultPadding),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding * 1.5,
                    ),
                    child: Text(
                      appLocalization.withThisOrderTheyChoose,
                      style: Constants.textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: extraSalesCategory.products.length,
                        itemBuilder: ((context, index) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: Constants.defaultPadding * 17,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Constants.defaultPadding),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    right: BorderSide(
                                      color: Constants.lightGrayColor,
                                      width: 1.0,
                                    ),
                                  )),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: Constants.defaultPadding * 10.5,
                                        height: Constants.defaultPadding * 8.8,
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Constants.defaultPadding * 0.7),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                              child: extraSalesCategory
                                                          .products[index]
                                                          .imageUrls
                                                          .isEmpty ||
                                                      extraSalesCategory
                                                          .products[index]
                                                          .imageUrls
                                                          .first
                                                          .isEmpty
                                                  ? Image.asset(
                                                      'assets/decorations/no_image_url.png',
                                                      fit: BoxFit.cover)
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          extraSalesCategory
                                                              .products[index]
                                                              .imageUrls
                                                              .first,
                                                    ),
                                            ),
                                            // extraSalesCategory.products[index].tag != ProductTags.none
                                            //     ? Positioned(
                                            //         top: Constants.defaultPadding * 0.4,
                                            //         left: Constants.defaultPadding * 0.4,
                                            //         child: Container(
                                            //           padding: const EdgeInsets.symmetric(
                                            //               horizontal: 10, vertical: 5),
                                            //           decoration: const BoxDecoration(
                                            //               color:
                                            //                   Constants.thirdPrimaryColor,
                                            //               borderRadius: BorderRadius.all(
                                            //                   Radius.circular(6))),
                                            //           child: Center(
                                            //             child: Text(
                                            //               "СКИДКА",
                                            //               textAlign: TextAlign.center,
                                            //               style: Constants
                                            //                   .textTheme.bodyMedium!
                                            //                   .copyWith(
                                            //                 color: Colors.white,
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ))
                                            //     : const SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: Constants.defaultPadding *
                                                0.125),
                                        child: Text(
                                          extraSalesCategory
                                              .products[index].title,
                                          textAlign: TextAlign.center,
                                          style: Constants
                                              .textTheme.headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Constants.blackColor,
                                                  height: 1.15),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: Constants.defaultPadding),
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${extraSalesCategory.products[index].price}",
                                              style: Constants
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                      color: Constants
                                                          .darkGrayColor,
                                                      height: 1.75),
                                              children: [
                                                TextSpan(
                                                    text: "₸",
                                                    style:
                                                        Constants.tengeStyle),
                                                TextSpan(
                                                    text:
                                                        " • 590 ${appLocalization.kcal}",
                                                    style: Constants
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: Constants
                                                                .darkGrayColor,
                                                            height: 1.75))
                                              ]),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              Constants.defaultPadding * 10.5,
                                          child: OutlinedButton(
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                    CartItemAdded(CartItemModel(
                                                        product:
                                                            extraSalesCategory
                                                                    .products[
                                                                index],
                                                        count: 1,
                                                        orderModifiers: const [])));

                                                final successSnackBar =
                                                    Constants.successSnackBar(
                                                        context,
                                                        appLocalization
                                                            .itemAddedToCart);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        successSnackBar);

                                                setState(() {
                                                  buttonText =
                                                      appLocalization.next;
                                                });
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      Constants.backgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Constants
                                                          .purpleColor)),
                                              child: Text(
                                                  appLocalization.addToCart
                                                      .toUpperCase(),
                                                  style: Constants
                                                      .headlineTextTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                          color: Constants
                                                              .purpleColor,
                                                          fontWeight: FontWeight
                                                              .bold))))
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/checkout');
                      },
                      child: Text(
                        buttonText,
                        style: Constants.textTheme.titleLarge!.copyWith(
                            fontSize: 12, decoration: TextDecoration.underline),
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
