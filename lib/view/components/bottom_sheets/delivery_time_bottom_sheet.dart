import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Delivery time bottom sheet for chossing delivey time in Checkout Screen
class DeliveryTimeBottomSheet extends StatefulWidget {
  const DeliveryTimeBottomSheet({Key? key}) : super(key: key);

  @override
  State<DeliveryTimeBottomSheet> createState() =>
      _DeliveryTimeBottomSheetState();
}

class _DeliveryTimeBottomSheetState extends State<DeliveryTimeBottomSheet> {
  late List<String> deliveryDays;
  List<String> fullTimeRanges = [];
  int selectedDeliveryDay = 0;
  int selectedDeliveryHour = 0;

  @override
  void initState() {
    deliveryDays = [
      "Сегодня",
    ];
    for (int i = 1; i <= 7; i++) {
      var tmp = DateTime.now().add(Duration(days: i));
      deliveryDays.add(
        "${tmp.day} ${Config.getMonthString(tmp.month)}",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoadedState) {
              List<String> todayDeliveryHours =
                  Config.getTodayTimeRanges(state.contactsModel.closeHour);
              if (fullTimeRanges.isEmpty) {
                fullTimeRanges = Config.getFullTimeRanges(
                    state.contactsModel.openHour,
                    state.contactsModel.closeHour);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: Constants.defaultPadding * 2,
                        bottom: Constants.defaultPadding * 1.5,
                        left: Constants.defaultPadding),
                    child: Text("Укажите время доставки",
                        style:
                            Constants.headlineTextTheme.displayMedium!.copyWith(
                          color: Constants.primaryColor,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                        left: Constants.defaultPadding),
                    child: Text(
                      "Будем стараться доставить Ваш заказ максимально быстро (с погрешностью ±10 минут)",
                      style:
                          Constants.textTheme.bodyLarge!.copyWith(height: 1.25),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List.generate(
                              deliveryDays.length,
                              (index) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedDeliveryDay = index;
                                        selectedDeliveryHour = 0;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: index == 0
                                              ? Constants.defaultPadding
                                              : 0,
                                          right:
                                              Constants.defaultPadding * 0.75),
                                      decoration: BoxDecoration(
                                          color:
                                              Constants.secondBackgroundColor,
                                          border: Border.all(
                                              width: 1,
                                              color: index ==
                                                      selectedDeliveryDay
                                                  ? Constants.secondPrimaryColor
                                                  : Colors.transparent),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        deliveryDays[index],
                                        style: Constants
                                            .textTheme.headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: index ==
                                                        selectedDeliveryDay
                                                    ? Constants
                                                        .secondPrimaryColor
                                                    : Constants.darkGrayColor),
                                      ),
                                    ),
                                  ))),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: selectedDeliveryDay != 0
                              ? List.generate(
                                  fullTimeRanges.length,
                                  (index) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedDeliveryHour = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: index == 0
                                                  ? Constants.defaultPadding
                                                  : 0,
                                              right: Constants.defaultPadding *
                                                  0.75),
                                          decoration: BoxDecoration(
                                              color: Constants
                                                  .secondBackgroundColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: index ==
                                                          selectedDeliveryHour
                                                      ? Constants
                                                          .secondPrimaryColor
                                                      : Colors.transparent),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Text(
                                            fullTimeRanges[index],
                                            style: Constants
                                                .textTheme.headlineSmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: index ==
                                                            selectedDeliveryHour
                                                        ? Constants
                                                            .secondPrimaryColor
                                                        : Constants
                                                            .darkGrayColor),
                                          ),
                                        ),
                                      ))
                              : List.generate(
                                  todayDeliveryHours.length,
                                  (index) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedDeliveryHour = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: index == 0
                                                  ? Constants.defaultPadding
                                                  : 0,
                                              right: Constants.defaultPadding *
                                                  0.75),
                                          decoration: BoxDecoration(
                                              color: Constants
                                                  .secondBackgroundColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: index ==
                                                          selectedDeliveryHour
                                                      ? Constants
                                                          .secondPrimaryColor
                                                      : Colors.transparent),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Text(
                                            todayDeliveryHours[index],
                                            style: Constants
                                                .textTheme.headlineSmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: index ==
                                                            selectedDeliveryHour
                                                        ? Constants
                                                            .secondPrimaryColor
                                                        : Constants
                                                            .darkGrayColor),
                                          ),
                                        ),
                                      ))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding * 2,
                        left: Constants.defaultPadding,
                        right: Constants.defaultPadding),
                    child: CustomElevatedButton(
                        text: "ВЫБРАТЬ",
                        function: () {
                          if (selectedDeliveryDay == 0 &&
                              selectedDeliveryHour == 0) {
                            context.read<CheckoutBloc>().add(
                                const CheckoutDeliveryTimeTypeChanged(
                                    DeliveryTimeType.fast));
                          } else if (selectedDeliveryDay == 0) {
                            var checkoutBloc = context.read<CheckoutBloc>();
                            checkoutBloc.add(
                                const CheckoutDeliveryTimeTypeChanged(
                                    DeliveryTimeType.certainTime));
                            checkoutBloc.add(CheckoutCertainTimeOrderChanged(
                                certainDayOrder:
                                    deliveryDays[selectedDeliveryDay],
                                certainTimeOrder:
                                    todayDeliveryHours[selectedDeliveryHour]));
                          } else {
                            var checkoutBloc = context.read<CheckoutBloc>();
                            checkoutBloc.add(
                                const CheckoutDeliveryTimeTypeChanged(
                                    DeliveryTimeType.certainTime));
                            checkoutBloc.add(CheckoutCertainTimeOrderChanged(
                                certainDayOrder:
                                    deliveryDays[selectedDeliveryDay],
                                certainTimeOrder:
                                    fullTimeRanges[selectedDeliveryHour]));
                          }
                          Navigator.pop(context);
                        }),
                  )
                ],
              );
            }
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Constants.defaultPadding * 0.75),
                  child: const ShimmerListTile(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
