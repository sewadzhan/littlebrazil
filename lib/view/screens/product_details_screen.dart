import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/order_modifier.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  //Controllers for each group modifiers
  List<OrderModifier> modifierControllers = [];
  int count = 1; //Product count

  @override
  void initState() {
    //modifierControllers init
    for (var i = 0; i < widget.product.groupModifiers.length; i++) {
      if (widget.product.groupModifiers[i].childModifiers.isNotEmpty) {
        //Default value of group modifier - first child
        modifierControllers.add(OrderModifier(
            amount: 1,
            productGroupId: widget.product.groupModifiers[i].id,
            modifier: widget.product.groupModifiers[i].childModifiers.first,
            productGroupName: widget.product.groupModifiers[i].name));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.backgroundColor,
        centerTitle: true,
        leading: TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: SizedBox(
            width: 25,
            child: SvgPicture.asset('assets/icons/arrow-left.svg',
                colorFilter: const ColorFilter.mode(
                    Constants.darkGrayColor, BlendMode.srcIn)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.product.tag == ProductTags.none
              ? ""
              : Config.getTagTitle(widget.product.tag),
          style: Constants.headlineTextTheme.displaySmall!.copyWith(
              color: Config.getTagColor(widget.product.tag), fontSize: 22),
        ),
        // title: widget.product.tag != ProductTags.none
        //     ? Chip(
        //         padding:
        //             const EdgeInsets.only(left: 7, right: 7, top: 4, bottom: 0),
        //         label: Text(
        //           Config.getTagTitle(widget.product.tag),
        //           style: Constants.headlineTextTheme.headlineMedium!.copyWith(
        //               fontWeight: FontWeight.w600,
        //               color: Colors.white,
        //               height: 0.8),
        //         ),
        //         backgroundColor: Config.getTagColor(widget.product.tag),
        //       )
        //     : const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
              child: CarouselSlider(
                  items: widget.product.imageUrls
                      .map(
                        (e) => ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: widget.product.imageUrls.isEmpty ||
                                    widget.product.imageUrls.first.isEmpty
                                ? Image.asset(
                                    'assets/decorations/no_image_url.png')
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: size.width,
                                    height: size.height * 0.4,
                                    imageUrl: widget.product.imageUrls.first,
                                  )),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 220,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.91,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.17,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                  vertical: Constants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                    child: Text(widget.product.title,
                        style: Constants.headlineTextTheme.displayLarge!
                            .copyWith(
                                color: Constants.primaryColor, height: 0.9)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                    child: Text(
                      widget.product.description,
                      style: Constants.textTheme.bodyLarge,
                    ),
                  ),
                  // widget.product.features.isEmpty
                  //     ? const SizedBox.shrink()
                  //     : Container(
                  //         width: 160,
                  //         padding: const EdgeInsets.all(10),
                  //         decoration: const BoxDecoration(
                  //             color: Constants.grayBackgroundColor,
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(8))),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(
                  //                   bottom: Constants.defaultPadding * 0.4),
                  //               child: Text(
                  //                 "Характеристика",
                  //                 style: Constants.textTheme.titleLarge,
                  //               ),
                  //             ),
                  //             MediaQuery.removePadding(
                  //               context: context,
                  //               removeTop: true,
                  //               removeBottom: true,
                  //               child: ListView.builder(
                  //                   shrinkWrap: true,
                  //                   itemCount: widget.product.features.length,
                  //                   itemBuilder: (context, index) => Padding(
                  //                         padding: EdgeInsets.only(
                  //                             bottom:
                  //                                 Constants.defaultPadding *
                  //                                     0.4),
                  //                         child: Row(
                  //                           children: [
                  //                             SvgPicture.asset(
                  //                               widget.product.features[index]
                  //                                   .iconPath,
                  //                               width: 16,
                  //                             ),
                  //                             SizedBox(
                  //                                 width: Constants
                  //                                         .defaultPadding *
                  //                                     0.5),
                  //                             Text(
                  //                               "${widget.product.features[index].value} ${widget.product.features[index].dimension}",
                  //                               style: Constants
                  //                                   .textTheme.bodyMedium,
                  //                             )
                  //                           ],
                  //                         ),
                  //                       )),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  // Column(
                  //     children: List.generate(
                  //         widget.product.groupModifiers.length,
                  //         (index) => Padding(
                  //               padding: EdgeInsets.symmetric(
                  //                   vertical: Constants.defaultPadding * 0.75),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   const Divider(
                  //                     height: 1,
                  //                     thickness: 1,
                  //                     color: Constants.lightGrayColor,
                  //                   ),
                  //                   Padding(
                  //                     padding: EdgeInsets.only(
                  //                         top: Constants.defaultPadding,
                  //                         bottom:
                  //                             Constants.defaultPadding * 0.75),
                  //                     child: Text(
                  //                         widget.product.groupModifiers[index]
                  //                             .name,
                  //                         style: Constants
                  //                             .textTheme.headlineSmall!
                  //                             .copyWith(
                  //                           color: Constants.darkGrayColor,
                  //                         )),
                  //                   ),
                  //                   Column(
                  //                     children: List.generate(
                  //                         widget.product.groupModifiers[index]
                  //                             .childModifiers.length,
                  //                         (childIndex) => RadioListTile(
                  //                             dense: true,
                  //                             contentPadding: EdgeInsets.zero,
                  //                             activeColor:
                  //                                 Constants.primaryColor,
                  //                             value: widget
                  //                                 .product
                  //                                 .groupModifiers[index]
                  //                                 .childModifiers[childIndex],
                  //                             groupValue:
                  //                                 modifierControllers[index]
                  //                                     .modifier,
                  //                             title: Text(
                  //                                 widget
                  //                                     .product
                  //                                     .groupModifiers[index]
                  //                                     .childModifiers[
                  //                                         childIndex]
                  //                                     .name,
                  //                                 style: Constants
                  //                                     .textTheme.headlineSmall!
                  //                                     .copyWith(
                  //                                         fontWeight: FontWeight
                  //                                             .normal)),
                  //                             onChanged: (value) {
                  //                               if (value != null) {
                  //                                 setState(() {
                  //                                   OrderModifier previous =
                  //                                       modifierControllers[
                  //                                           index];
                  //                                   modifierControllers[index] =
                  //                                       previous.copyWith(
                  //                                           modifier: value);
                  //                                 });
                  //                               }
                  //                             })),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(Constants.defaultPadding),
          decoration: const BoxDecoration(
              color: Constants.backgroundColor,
              border: Border(
                  top: BorderSide(color: Constants.lightGrayColor, width: 1))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              margin: EdgeInsets.only(right: Constants.defaultPadding * 0.5),
              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Constants.secondPrimaryColor, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 45,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            overlayColor: Constants.secondPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: Constants.defaultPadding),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            //Small vibration for feedback
                            HapticFeedback.lightImpact();

                            setState(() {
                              if (count > 1) {
                                count = count - 1;
                              }
                            });
                          },
                          child: SvgPicture.asset('assets/icons/minus.svg',
                              width: 15,
                              colorFilter: const ColorFilter.mode(
                                Constants.secondPrimaryColor,
                                BlendMode.srcIn,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        width: 20,
                        child: Text(count.toString(),
                            textAlign: TextAlign.center,
                            style: Constants.headlineTextTheme.headlineMedium!
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Constants.secondPrimaryColor,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            overlayColor: Constants.secondPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: Constants.defaultPadding),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            //Small vibration for feedback
                            HapticFeedback.lightImpact();

                            setState(() {
                              if (count < 100) {
                                count = count + 1;
                              }
                            });
                          },
                          child: SvgPicture.asset('assets/icons/plus.svg',
                              width: 15,
                              colorFilter: const ColorFilter.mode(
                                  Constants.secondPrimaryColor,
                                  BlendMode.srcIn))),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: CustomElevatedButton(
                    text:
                        "${appLocalization.addToCart} • ${widget.product.price * count}",
                    withTengeSign: true,
                    function: () {
                      context.read<CartBloc>().add(CartItemAdded(CartItemModel(
                          product: widget.product,
                          count: count,
                          orderModifiers: modifierControllers)));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.successSnackBar(
                              context, appLocalization.itemAddedToCart));
                    })),
          ]),
        ),
      ),
    );
  }
}
