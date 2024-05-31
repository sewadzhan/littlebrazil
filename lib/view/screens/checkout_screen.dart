import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/delivery_point.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/order/order_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/address_bottom_sheet.dart';
import 'package:littlebrazil/view/components/bottom_sheets/cashback_bottom_sheet.dart';
import 'package:littlebrazil/view/components/bottom_sheets/delivery_time_bottom_sheet.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return SliverBody(
      title: appLocalization.checkout,
      bottomBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return SafeArea(
              child: Container(
                  padding: EdgeInsets.all(Constants.defaultPadding),
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
                            bottom: Constants.defaultPadding * 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocalization.discount,
                              style: Constants.textTheme.headlineSmall,
                            ),
                            BlocBuilder<CartBloc, CartState>(
                              builder: (context, state) {
                                if (state is CartLoaded) {
                                  return RichText(
                                    text: TextSpan(
                                        text: "${state.cart.discount} ",
                                        style:
                                            Constants.textTheme.headlineSmall,
                                        children: [
                                          TextSpan(
                                              text: "₸",
                                              style: Constants.tengeStyle
                                                  .copyWith(
                                                      fontSize: Constants
                                                          .textTheme
                                                          .bodyLarge!
                                                          .fontSize)),
                                        ]),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocalization.delivery,
                              style: Constants.textTheme.headlineSmall,
                            ),
                            BlocBuilder<CheckoutBloc, Checkout>(
                              builder: (context, state) {
                                return RichText(
                                  text: TextSpan(
                                      text: "${state.deliveryCost} ",
                                      style: Constants.textTheme.headlineSmall,
                                      children: [
                                        TextSpan(
                                            text: "₸",
                                            style: Constants.tengeStyle
                                                .copyWith(
                                                    fontSize: Constants
                                                        .textTheme
                                                        .bodyLarge!
                                                        .fontSize)),
                                      ]),
                                );
                              },
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
                              appLocalization.total,
                              style: Constants.textTheme.headlineSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                            ),
                            BlocBuilder<CheckoutBloc, Checkout>(
                              builder: (context, checkoutState) {
                                return BlocBuilder<CartBloc, CartState>(
                                  builder: (context, cartState) {
                                    if (cartState is CartLoaded) {
                                      return RichText(
                                        text: TextSpan(
                                            text:
                                                "${cartState.cart.subtotal - cartState.cart.discount + checkoutState.deliveryCost} ",
                                            style: Constants
                                                .textTheme.headlineSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                  text: "₸",
                                                  style: Constants.tengeStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Constants
                                                              .textTheme
                                                              .bodyLarge!
                                                              .fontSize)),
                                            ]),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<OrderBloc, OrderState>(
                        listener: (context, state) {
                          if (state is OrderSuccessful) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/successOrder',
                                (Route<dynamic> route) => false,
                                arguments: state.order);
                          } else if (state is OrderAcquiringInit) {
                            // Navigator.of(context).pushNamed('/payboxPayment',
                            //     arguments: state.order);
                          }
                        },
                        builder: (context, state) {
                          return CustomElevatedButton(
                              text: appLocalization.placeOrder,
                              isLoading: state is OrderLoading,
                              function: () {
                                CheckoutBloc checkoutBloc =
                                    context.read<CheckoutBloc>();
                                checkoutBloc.add(CheckoutCommentsChanged(
                                    comments: commentsController.text));
                                CartLoaded cartState = context
                                    .read<CartBloc>()
                                    .state as CartLoaded;
                                int subfinalValue = cartState.cart.subtotal -
                                    cartState.cart.discount +
                                    checkoutBloc.state.deliveryCost;

                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Constants.backgroundColor,
                                    elevation: 0,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                    ),
                                    builder: (context1) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value:
                                                  context.read<CheckoutBloc>(),
                                            ),
                                            BlocProvider.value(
                                              value:
                                                  context.read<ContactsCubit>(),
                                            ),
                                            BlocProvider.value(
                                              value:
                                                  context.read<CashbackBloc>(),
                                            ),
                                            BlocProvider.value(
                                              value: context.read<OrderBloc>(),
                                            ),
                                            BlocProvider.value(
                                              value: context.read<CartBloc>(),
                                            ),
                                            BlocProvider.value(
                                              value: context
                                                  .read<CurrentUserBloc>(),
                                            ),
                                          ],
                                          child: CashbackBottomSheet(
                                            subfinalValue: subfinalValue,
                                          ),
                                        ));
                              });
                        },
                      ),
                    ],
                  )),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
              vertical: Constants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                child: SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<CheckoutBloc, Checkout>(
                    builder: (context, state) {
                      return CupertinoSlidingSegmentedControl(
                          backgroundColor: Constants.secondBackgroundColor,
                          thumbColor: Constants.lightGreenColor,
                          groupValue: state.orderType,
                          children: <OrderType, Widget>{
                            OrderType.delivery: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Constants.defaultPadding * 0.5),
                                child: Text(
                                  appLocalization.delivery,
                                  style: Constants.textTheme.headlineSmall,
                                )),
                            OrderType.pickup: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Constants.defaultPadding * 0.5),
                                child: Text(appLocalization.pickup,
                                    style: Constants.textTheme.headlineSmall)),
                          },
                          onValueChanged: (value) {
                            context.read<CheckoutBloc>().add(
                                CheckoutOrderTypeChanged(value as OrderType));
                          });
                    },
                  ),
                ),
              ),
              BlocBuilder<CheckoutBloc, Checkout>(
                builder: (context, state) {
                  String title = state.orderType == OrderType.delivery
                      ? appLocalization.deliveryAddress
                      : appLocalization.pickupPoint;
                  return Text(title,
                      style: Constants.textTheme.headlineSmall!.copyWith(
                        color: Constants.primaryColor,
                      ));
                },
              ),
              BlocBuilder<CheckoutBloc, Checkout>(
                builder: (context, state) {
                  if (state.orderType == OrderType.delivery) {
                    if (state.address.address.isEmpty) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                          width: 25,
                          child: SvgPicture.asset('assets/icons/bus.svg'),
                        ),
                        title: Text(
                          appLocalization.addDeliveryAddress,
                          style: Constants.textTheme.bodyLarge,
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icons/arrow-right.svg',
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/addAddress');
                        },
                      );
                    }
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 25,
                        child: SvgPicture.asset('assets/icons/bus.svg'),
                      ),
                      title: Text(
                        state.address.address,
                        style: Constants.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        "${appLocalization.aptOffice} ${state.address.apartmentOrOffice}",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(color: Constants.middleGrayColor),
                      ),
                      trailing: SvgPicture.asset(
                        'assets/icons/arrow-right.svg',
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Constants.backgroundColor,
                            elevation: 0,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            builder: (context1) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<CheckoutBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<AddressBloc>(),
                                    ),
                                  ],
                                  child: const AddressBottomSheet(),
                                ));
                      },
                    );
                  }
                  return BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, contactState) {
                      if (contactState is ContactsLoadedState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 0.25),
                          child: Column(
                              children: contactState.contactsModel.pickupPoints
                                  .map((DeliveryPoint point) => RadioListTile(
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                      ),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Constants.secondPrimaryColor,
                                      value: point,
                                      groupValue: state.pickupPoint,
                                      title: Text(point.address,
                                          style: Constants
                                              .textTheme.headlineSmall!
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.normal)),
                                      onChanged: (Object? value) {
                                        context.read<CheckoutBloc>().add(
                                            CheckoutPickupPointChanged(
                                                (value as DeliveryPoint)));
                                      }))
                                  .toList()),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
              Text(appLocalization.deliveryTime,
                  style: Constants.textTheme.headlineSmall!.copyWith(
                    color: Constants.primaryColor,
                  )),
              BlocBuilder<CheckoutBloc, Checkout>(
                builder: (context, state) {
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 25,
                      child: SvgPicture.asset('assets/icons/clock.svg'),
                    ),
                    title: Text(
                      state.deliveryTime == DeliveryTimeType.fast
                          ? appLocalization.asSoonAsPossible
                          : "${state.certainDayOrder}, ${state.certainTimeOrder}",
                      style: Constants.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      state.deliveryTime == DeliveryTimeType.fast
                          ? appLocalization.today
                          : appLocalization.timeDifference,
                      style: Constants.textTheme.bodyMedium!
                          .copyWith(color: Constants.middleGrayColor),
                    ),
                    trailing: SvgPicture.asset(
                      'assets/icons/arrow-right.svg',
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Constants.backgroundColor,
                          elevation: 0,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          builder: (context1) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<CheckoutBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<ContactsCubit>(),
                                  ),
                                ],
                                child: const DeliveryTimeBottomSheet(),
                              ));
                    },
                  );
                },
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Text(appLocalization.additional,
                    style: Constants.textTheme.headlineSmall!.copyWith(
                      color: Constants.primaryColor,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: Constants.defaultPadding),
                          width: 25,
                          child: SvgPicture.asset('assets/icons/fork.svg'),
                        ),
                        Text(
                          appLocalization.cutlery,
                          style: Constants.textTheme.bodyLarge,
                        )
                      ],
                    ),
                    Container(
                      height: 35,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Constants.secondPrimaryColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  overlayColor: Constants.secondPrimaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        bottomLeft: Radius.circular(6)),
                                  ),
                                ),
                                onPressed: () {
                                  //Small vibration for feedback
                                  HapticFeedback.lightImpact();
                                  context.read<CheckoutBloc>().add(
                                      const CheckoutNumberOfCutleryDecreased());
                                },
                                child:
                                    SvgPicture.asset('assets/icons/minus.svg',
                                        width: 12,
                                        colorFilter: const ColorFilter.mode(
                                          Constants.secondPrimaryColor,
                                          BlendMode.srcIn,
                                        ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: SizedBox(
                              width: 20,
                              child: BlocBuilder<CheckoutBloc, Checkout>(
                                builder: (context, state) {
                                  return Text(state.numberOfCutlery.toString(),
                                      textAlign: TextAlign.center,
                                      style: Constants
                                          .headlineTextTheme.headlineMedium!
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Constants.secondPrimaryColor,
                                      ));
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 28,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  overlayColor: Constants.secondPrimaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                  ),
                                ),
                                onPressed: () {
                                  //Small vibration for feedback
                                  HapticFeedback.lightImpact();
                                  context.read<CheckoutBloc>().add(
                                      const CheckoutNumberOfCutleryIncreased());
                                },
                                child: SvgPicture.asset('assets/icons/plus.svg',
                                    width: 12,
                                    colorFilter: const ColorFilter.mode(
                                        Constants.secondPrimaryColor,
                                        BlendMode.srcIn))),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding * 1.25,
                ),
                child: CustomTextInputField(
                  controller: commentsController,
                  titleText: appLocalization.orderComments,
                  hintText: "",
                  maxLines: 3,
                ),
              ),
            ],
          )),
    );
  }
}
