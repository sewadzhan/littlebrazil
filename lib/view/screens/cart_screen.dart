import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/promocode/promocode_bloc.dart';
import 'package:littlebrazil/view/components/cart_item.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var promocodeController = TextEditingController();
    return SliverBody(
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              if (state.cart.items.isNotEmpty) {
                return TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: SizedBox(
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/icons/bin.svg',
                      colorFilter: const ColorFilter.mode(
                          Constants.darkGrayColor, BlendMode.srcIn),
                    ),
                  ),
                  onPressed: () {
                    Constants.showBottomSheetAlert(
                        context: context,
                        title: "Вы хотите очистить корзину?",
                        submit: "ОЧИСТИТЬ",
                        function: () {
                          context.read<CartBloc>().add(CartCleared());
                          Navigator.of(context).pop();
                        });
                  },
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      title: "Корзина",
      bottomBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cart.items.isNotEmpty) {
              return Container(
                  padding: EdgeInsets.only(
                      left: Constants.defaultPadding,
                      right: Constants.defaultPadding,
                      top: Constants.defaultPadding,
                      bottom: Constants.defaultPadding * 2),
                  decoration: const BoxDecoration(
                      color: Constants.backgroundColor,
                      border: Border(
                          top: BorderSide(
                              color: Constants.lightGrayColor, width: 1))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Скидка",
                              style: Constants.textTheme.headlineSmall,
                            ),
                            Text(
                              "${state.cart.discount} ₸",
                              style: Constants.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Подытог",
                              style: Constants.textTheme.headlineSmall,
                            ),
                            Text(
                              "${state.cart.subtotal} ₸",
                              style: Constants.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton(
                          text: "ОФОРМИТЬ ЗАКАЗ",
                          function: () async {
                            // var isAuthenticated =
                            //     context.read<AuthCubit>().state != null;

                            // if (!isAuthenticated) {
                            //   Navigator.pushNamed(context, '/auth');
                            //   return;
                            // }
                            // Navigator.pushNamed(context, "/checkout");
                          }),
                    ],
                  ));
            }
          }
          //if empty cart
          return const SizedBox.shrink();
        },
      ),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cart.items.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Constants.defaultPadding,
                        right: Constants.defaultPadding,
                        bottom: Constants.defaultPadding * 1.5),
                    child: TextFormField(
                      autofocus: false,
                      controller: promocodeController,
                      style: Constants.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding * 0.75,
                            vertical: Constants.defaultPadding),
                        hintText: "Введите промокод",
                        hintStyle: Constants.textTheme.bodyLarge!
                            .copyWith(color: Constants.textInputColor),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Constants.thirdPrimaryColor,
                        )),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Constants.textInputColor,
                        )),
                        suffixIcon: BlocConsumer<PromocodeBloc, PromocodeState>(
                          listener: (context, state) {
                            if (state is PromocodeSubmitSuccess) {
                              promocodeController.clear();
                              var successSnackBar = Constants.successSnackBar(
                                  context, "Промокод успешно применен");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successSnackBar);
                            } else if (state is PromocodeFailure) {
                              var errorSnackBar = Constants.errorSnackBar(
                                  context, state.message);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(errorSnackBar);
                            }
                          },
                          builder: (context, state) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                              onPressed: state is PromocodeLoadSuccess
                                  ? () {
                                      context.read<PromocodeBloc>().add(
                                          PromocodeSubmited(
                                              promocodeController.text));
                                    }
                                  : null,
                              child: SizedBox(
                                width: 30,
                                child: SvgPicture.asset(
                                  'assets/icons/check-mark.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Constants.primaryColor, BlendMode.srcIn),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: state.cart.items.length,
                        itemBuilder: (context, index) => Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context.read<CartBloc>().add(CartItemRemoved(
                                    state.cart.items[index],
                                  ));
                            },
                            key: ObjectKey(state.cart.items[index]),
                            background: Container(
                              alignment: Alignment.centerRight,
                              width: 60,
                              color: Constants.errorColor,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      right: Constants.defaultPadding),
                                  width: 25,
                                  height: 25,
                                  child: SvgPicture.asset(
                                      'assets/icons/bin.svg',
                                      colorFilter: const ColorFilter.mode(
                                          Constants.backgroundColor,
                                          BlendMode.srcIn))),
                            ),
                            child: CartItem(
                              cartItem: state.cart.items[index],
                            )),
                      ))
                ],
              );
            }
            //Empty cart
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BlocBuilder<ContactsCubit, ContactsState>(
                //   builder: (context, state) {
                //     return RichText(
                //       textAlign: TextAlign.center,
                //       text: TextSpan(
                //           text: state is ContactsLoadedState
                //               ? "Корзина пуста.\nДобавьте товар в корзину\n*Минимальная сумма заказа ${state.contactsModel.minOrderSum}"
                //               : "Корзина пуста.\nДобавьте товар в корзину",
                //           style: Constants.textTheme.bodyLarge!.copyWith(
                //             color: Constants.middleGrayColor,
                //           ),
                //           children: [
                //             TextSpan(
                //                 text: state is ContactsLoadedState ? "₸" : "",
                //                 style: Constants.tengeStyle.copyWith(
                //                     color: Constants.middleGrayColor,
                //                     fontSize: 14))
                //           ]),
                //     );
                //   },
                // ),
              ],
            );
          }
          //Cart loading state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
