import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/promocode/promocode_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/cross_sales_bottom_sheet.dart';
import 'package:littlebrazil/view/components/bottom_sheets/not_working_bottom_sheet.dart';
import 'package:littlebrazil/view/components/cart_item.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    var promocodeController = TextEditingController();
    Size size = MediaQuery.of(context).size;

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
                        title: appLocalization.doYouWantToClearTheCart,
                        submit: appLocalization.clear,
                        cancel: appLocalization.cancel,
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
      title: appLocalization.cart,
      bottomBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cart.items.isNotEmpty) {
              return SafeArea(
                child: Container(
                    padding: EdgeInsets.all(
                      Constants.defaultPadding,
                    ),
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
                                appLocalization.discount,
                                style: Constants.textTheme.headlineSmall,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "${state.cart.discount} ",
                                    style: Constants.textTheme.headlineSmall,
                                    children: [
                                      TextSpan(
                                          text: "₸",
                                          style: Constants.tengeStyle.copyWith(
                                              fontSize: Constants.textTheme
                                                  .bodyLarge!.fontSize)),
                                    ]),
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
                                appLocalization.subtotal,
                                style: Constants.textTheme.headlineSmall,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "${state.cart.subtotal} ",
                                    style: Constants.textTheme.headlineSmall,
                                    children: [
                                      TextSpan(
                                          text: "₸",
                                          style: Constants.tengeStyle.copyWith(
                                              fontSize: Constants.textTheme
                                                  .bodyLarge!.fontSize)),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        CustomElevatedButton(
                            text: appLocalization.placeAnOrder,
                            function: () async {
                              var isAuthenticated =
                                  context.read<AuthCubit>().state != null;
                              if (!isAuthenticated) {
                                Navigator.pushNamed(context, '/auth');
                                return;
                              }

                              //Not working bottom sheet
                              final ContactsCubit contactsCubit =
                                  context.read<ContactsCubit>();
                              if (!contactsCubit.isRestaurantWorking) {
                                showModalBottomSheet(
                                    backgroundColor: Constants.backgroundColor,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                    ),
                                    context: context,
                                    builder: (context) => NotWorkingBottomSheet(
                                        openHour: (contactsCubit.state
                                                as ContactsLoadedState)
                                            .contactsModel
                                            .openHour,
                                        closeHour: (contactsCubit.state
                                                as ContactsLoadedState)
                                            .contactsModel
                                            .closeHour));
                                return;
                              }
                              //Cross Sales bottom sheet
                              showModalBottomSheet(
                                  backgroundColor: Constants.backgroundColor,
                                  elevation: 0,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                  ),
                                  context: context,
                                  builder: (context1) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                              value: context.read<MenuCubit>()),
                                          BlocProvider.value(
                                              value: context.read<CartBloc>())
                                        ],
                                        child: const ExtraSalesBottomSheet(),
                                      ));
                            }),
                      ],
                    )),
              );
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
                        hintText: appLocalization.enterPromoCode,
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
                                  context,
                                  appLocalization.promocodeAppliedSuccessfully);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successSnackBar);
                            } else if (state is PromocodeFailure) {
                              String errorMessage =
                                  appLocalization.unexpectedError;
                              switch (state.message) {
                                case "promoCodeNotApplicable":
                                  errorMessage =
                                      appLocalization.promoCodeNotApplicable;
                                case "promoCodeSingleUse":
                                  errorMessage =
                                      appLocalization.promoCodeSingleUse;
                                case "invalidPromoCode":
                                  errorMessage =
                                      appLocalization.invalidPromoCode;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.errorSnackBar(context, errorMessage,
                                      duration:
                                          const Duration(milliseconds: 500)));
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
            return SizedBox(
              width: size.width,
              height: size.height * 0.8,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      top: 0,
                      left: 10,
                      child: SvgPicture.asset(
                          'assets/decorations/cart-top-left.svg')),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/decorations/cart-top-right.svg',
                        width: 200,
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: SvgPicture.asset(
                          'assets/decorations/cart-bottom-left.svg')),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/decorations/cart-bottom-right.svg',
                        width: 220,
                      )),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 7),
                    child: Text(
                      "${appLocalization.cartIsEmpty}\n${appLocalization.addDishesToCart}",
                      style: Constants.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          //Cart loading state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
