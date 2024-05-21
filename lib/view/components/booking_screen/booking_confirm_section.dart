import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/booking/booking_cubit.dart';
import 'package:littlebrazil/view/components/list_tiles/booking_list_tile.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingConfirmSection extends StatelessWidget {
  const BookingConfirmSection({super.key, required this.comments});
  final String comments;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final BookingLoadedState bookingState =
        context.read<BookingCubit>().state as BookingLoadedState;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Constants.defaultPadding),
          child: Text(appLocalization.confirmDetails,
              style: Constants.headlineTextTheme.displaySmall!.copyWith(
                color: Constants.primaryColor,
              )),
        ),
        BookingListTile(
          title: appLocalization.reservationDate,
          iconPath: 'assets/icons/calendar.svg',
          text: bookingState.selectedBookingDay ?? "",
        ),
        BookingListTile(
          title: appLocalization.time,
          iconPath: 'assets/icons/clock.svg',
          text: bookingState.selectedBookingTime ?? "",
        ),
        BookingListTile(
          title: appLocalization.numberOfGuests,
          iconPath: 'assets/icons/users.svg',
          text: bookingState.numberOfPersons.toString(),
        ),
        BookingListTile(
          title: appLocalization.comments,
          iconPath: 'assets/icons/pencil.svg',
          text: comments.isNotEmpty ? comments : appLocalization.noComments,
        )
      ],
    );
  }
}
