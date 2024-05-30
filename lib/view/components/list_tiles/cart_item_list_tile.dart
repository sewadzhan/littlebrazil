import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CartItemListTile extends StatelessWidget {
  const CartItemListTile({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: cartItem.orderModifiers.isEmpty
                            ? Constants.defaultPadding * 0.5
                            : 5),
                    child: Text(
                      cartItem.product.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Constants.textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: cartItem.orderModifiers.isEmpty
                            ? 0
                            : Constants.defaultPadding * 0.25),
                    child: Column(
                        children: List.generate(
                            cartItem.orderModifiers.length,
                            (modIndex) => Text(
                                  "${cartItem.orderModifiers[modIndex].productGroupName}: ${cartItem.orderModifiers[modIndex].modifier.name}",
                                  style: Constants.textTheme.bodyMedium!
                                      .copyWith(
                                          color: Constants.middleGrayColor),
                                ))),
                  ),
                  Row(
                    children: [
                      Text(
                        "${cartItem.count}x",
                        style: Constants.textTheme.bodyMedium!.copyWith(
                            fontSize: 10, color: Constants.middleGrayColor),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                            text: "${cartItem.product.price} ",
                            style: Constants.textTheme.titleLarge,
                            children: [
                              TextSpan(
                                  text: "₸",
                                  style: Constants.tengeStyle.copyWith(
                                      fontSize: Constants
                                          .textTheme.bodyMedium!.fontSize)),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
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
    );
  }
}
