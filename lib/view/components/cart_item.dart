import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    if (cartItem.product is Product) {
      return _usualCartItem(context, cartItem);
    }
    return const SizedBox.shrink();
  }

  Widget _usualCartItem(BuildContext context, CartItemModel cartItem) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 67,
                  height: 67,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: cartItem.product.imageUrls.isEmpty ||
                              cartItem.product.imageUrls.first.isEmpty
                          ? Image.asset('assets/decorations/no_image_url.png',
                              fit: BoxFit.cover)
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: cartItem.product.imageUrls.first,
                            )),
                ),
                SizedBox(width: Constants.defaultPadding * 0.75),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: cartItem.orderModifiers.isEmpty
                                ? Constants.defaultPadding
                                : 5),
                        child: Column(
                          children: [
                            Text(
                              cartItem.product.title,
                              style: Constants.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: cartItem.orderModifiers.isEmpty
                                ? 0
                                : Constants.defaultPadding * 0.5),
                        child: Column(
                            children: List.generate(
                                cartItem.orderModifiers.length,
                                (index) => Text(
                                      "${cartItem.orderModifiers[index].productGroupName}: ${cartItem.orderModifiers[index].modifier.name}",
                                      style: Constants.textTheme.bodyMedium!
                                          .copyWith(
                                              color: Constants.darkGrayColor),
                                    ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Constants.secondPrimaryColor,
                                    width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        overlayColor:
                                            Constants.secondPrimaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6)),
                                        ),
                                      ),
                                      onPressed: () {
                                        //Small vibration for feedback
                                        HapticFeedback.lightImpact();

                                        context.read<CartBloc>().add(
                                            CartItemDecreased(CartItemModel(
                                                product: cartItem.product,
                                                count: 1,
                                                orderModifiers:
                                                    cartItem.orderModifiers)));
                                      },
                                      child: SvgPicture.asset(
                                          'assets/icons/minus.svg',
                                          width: 12,
                                          colorFilter: const ColorFilter.mode(
                                            Constants.secondPrimaryColor,
                                            BlendMode.srcIn,
                                          ))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: SizedBox(
                                    width: 20,
                                    child: Text("${cartItem.count}",
                                        textAlign: TextAlign.center,
                                        style: Constants
                                            .headlineTextTheme.headlineMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.secondPrimaryColor,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        overlayColor:
                                            Constants.secondPrimaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomRight: Radius.circular(6)),
                                        ),
                                      ),
                                      onPressed: () {
                                        //Small vibration for feedback
                                        HapticFeedback.lightImpact();

                                        context.read<CartBloc>().add(
                                            CartItemAdded(CartItemModel(
                                                product: cartItem.product,
                                                count: 1,
                                                orderModifiers:
                                                    cartItem.orderModifiers)));
                                      },
                                      child: SvgPicture.asset(
                                          'assets/icons/plus.svg',
                                          width: 12,
                                          colorFilter: const ColorFilter.mode(
                                              Constants.secondPrimaryColor,
                                              BlendMode.srcIn))),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${cartItem.count}x",
                                style: Constants.textTheme.bodyMedium!.copyWith(
                                    fontSize: 10,
                                    color: Constants.darkGrayColor),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${cartItem.product.price} ₸",
                                style: Constants.textTheme.titleLarge,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Constants.lightGrayColor,
          ),
        ],
      ),
    );
  }
}
