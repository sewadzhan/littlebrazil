import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/booking/booking_cubit.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:littlebrazil/view/config/constants.dart';

//First Booking Screen Section for date and time select
class BookingDateTimeSection extends StatelessWidget {
  const BookingDateTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> fullTimeRanges = [];
    final appLocalization = AppLocalizations.of(context)!;
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
    final List<String> deliveryDays = Config.getListOfDeliveryDays(
        todayString: appLocalization.today,
        languageCode: currentLocale.languageCode);

    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoadedState) {
          List<String> todayDeliveryHours = Config.getTodayTimeRanges(
              isBooking: true,
              state.contactsModel.openHour,
              state.contactsModel.closeHour,
              currentLocale.languageCode);
          if (fullTimeRanges.isEmpty) {
            fullTimeRanges = Config.getFullTimeRanges(
                state.contactsModel.openHour, state.contactsModel.closeHour);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(appLocalization.dateTimeOfReservation,
                    style: Constants.headlineTextTheme.displaySmall!.copyWith(
                      color: Constants.primaryColor,
                    )),
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
                          (index) => Padding(
                                padding: EdgeInsets.only(
                                    right: Constants.defaultPadding * 0.75),
                                child: InkWell(
                                  onTap: () {
                                    if (index == 0) {
                                      context
                                          .read<BookingCubit>()
                                          .changeBookingDayAndTime(
                                              selectedBookingDay:
                                                  deliveryDays[0],
                                              selectedBookingTime:
                                                  todayDeliveryHours[0]);
                                      return;
                                    }
                                    context
                                        .read<BookingCubit>()
                                        .changeBookingDayAndTime(
                                            selectedBookingDay:
                                                deliveryDays[index],
                                            selectedBookingTime:
                                                fullTimeRanges[0]);
                                  },
                                  child:
                                      BlocBuilder<BookingCubit, BookingState>(
                                    builder: (context, state) {
                                      if (state is BookingLoadedState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Constants
                                                  .secondBackgroundColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: deliveryDays[index] ==
                                                          state
                                                              .selectedBookingDay
                                                      ? Constants
                                                          .secondPrimaryColor
                                                      : Colors.transparent),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Text(
                                            deliveryDays[index],
                                            style: Constants
                                                .textTheme.headlineSmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: deliveryDays[
                                                                index] ==
                                                            state
                                                                .selectedBookingDay
                                                        ? Constants
                                                            .secondPrimaryColor
                                                        : Constants
                                                            .darkGrayColor),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      if (state is BookingLoadedState) {
                        return Row(
                            children: state.selectedBookingDay !=
                                    deliveryDays[0]
                                ? List.generate(
                                    fullTimeRanges.length,
                                    (index) => Padding(
                                          padding: EdgeInsets.only(
                                              // left: index == 0
                                              //     ? Constants.defaultPadding
                                              //     : 0,
                                              right: Constants.defaultPadding *
                                                  0.75),
                                          child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<BookingCubit>()
                                                  .changeBookingTime(
                                                      fullTimeRanges[index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Constants
                                                      .secondBackgroundColor,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: fullTimeRanges[
                                                                  index] ==
                                                              state
                                                                  .selectedBookingTime
                                                          ? Constants
                                                              .secondPrimaryColor
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Text(
                                                fullTimeRanges[index],
                                                style: Constants
                                                    .textTheme.headlineSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: fullTimeRanges[
                                                                    index] ==
                                                                state
                                                                    .selectedBookingTime
                                                            ? Constants
                                                                .secondPrimaryColor
                                                            : Constants
                                                                .darkGrayColor),
                                              ),
                                            ),
                                          ),
                                        ))
                                : List.generate(
                                    todayDeliveryHours.length,
                                    (index) => Padding(
                                          padding: EdgeInsets.only(
                                              // left: index == 0
                                              //     ? Constants.defaultPadding
                                              //     : 0,
                                              right: Constants.defaultPadding *
                                                  0.75),
                                          child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<BookingCubit>()
                                                  .changeBookingTime(
                                                      todayDeliveryHours[
                                                          index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Constants
                                                      .secondBackgroundColor,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: todayDeliveryHours[
                                                                  index] ==
                                                              state
                                                                  .selectedBookingTime
                                                          ? Constants
                                                              .secondPrimaryColor
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Text(
                                                todayDeliveryHours[index],
                                                style: Constants
                                                    .textTheme.headlineSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: todayDeliveryHours[
                                                                    index] ==
                                                                state
                                                                    .selectedBookingTime
                                                            ? Constants
                                                                .secondPrimaryColor
                                                            : Constants
                                                                .darkGrayColor),
                                              ),
                                            ),
                                          ),
                                        )));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                child: Text(appLocalization.numberOfGuests,
                    style: Constants.headlineTextTheme.displaySmall!.copyWith(
                      color: Constants.primaryColor,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding,
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(30, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          // left: index == 0
                          //     ? Constants.defaultPadding
                          //     : 0,
                          right: Constants.defaultPadding * 0.75),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<BookingCubit>()
                              .changeNumberOfPersons(index + 1);
                        },
                        child: BlocBuilder<BookingCubit, BookingState>(
                          builder: (context, state) {
                            if (state is BookingLoadedState) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Constants.secondBackgroundColor,
                                    border: Border.all(
                                        width: 1,
                                        color: state.numberOfPersons != null &&
                                                index ==
                                                    state.numberOfPersons! - 1
                                            ? Constants.secondPrimaryColor
                                            : Colors.transparent),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Text(
                                  "${index + 1}",
                                  style: Constants.textTheme.headlineSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: state.numberOfPersons !=
                                                      null &&
                                                  index ==
                                                      state.numberOfPersons! - 1
                                              ? Constants.secondPrimaryColor
                                              : Constants.darkGrayColor),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    );
                  })),
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
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
    );
  }
}
