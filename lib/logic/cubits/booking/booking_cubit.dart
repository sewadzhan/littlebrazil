import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import '../../blocs/current_user/current_user_bloc.dart';

part 'booking_state.dart';

//Cubit for realising functionality of Booking Screen
//This page contains Telegram API implementation
class BookingCubit extends Cubit<BookingState> {
  final CurrentUserBloc currentUserBloc;
  BookingCubit(this.currentUserBloc)
      : super(const BookingLoadedState(
          selectedBookingDay: null,
          selectedBookingTime: null,
          numberOfPersons: null,
        ));

  //Change the booking day in first section of Booking Screen
  void changeBookingDay(String selectedBookingDay) async {
    if (state is BookingLoadedState) {
      emit((state as BookingLoadedState).copyWith(
        selectedBookingDay: selectedBookingDay,
      ));
    }
  }

  //Change the booking time in first section of Booking Screen
  void changeBookingTime(String selectedBookingTime) async {
    if (state is BookingLoadedState) {
      emit((state as BookingLoadedState).copyWith(
        selectedBookingTime: selectedBookingTime,
      ));
    }
  }

  //Change the booking day and time in first section of Booking Screen
  void changeBookingDayAndTime({
    required String selectedBookingDay,
    required String selectedBookingTime,
  }) async {
    if (state is BookingLoadedState) {
      emit((state as BookingLoadedState).copyWith(
        selectedBookingTime: selectedBookingTime,
        selectedBookingDay: selectedBookingDay,
      ));
    }
  }

  //Change the number of persons in first section of Booking Screen
  void changeNumberOfPersons(int numberOfPersons) async {
    if (state is BookingLoadedState) {
      emit((state as BookingLoadedState)
          .copyWith(numberOfPersons: numberOfPersons));
    }
  }

  //Validate all fields
  bool validateFields() {
    if (state is BookingLoadedState &&
        (state as BookingLoadedState).numberOfPersons != null &&
        (state as BookingLoadedState).selectedBookingDay != null &&
        (state as BookingLoadedState).selectedBookingTime != null) {
      return true;
    }
    return false;
  }

  //Send booking info to telegram group
  void sendBooking({
    required String comments,
  }) async {
    final BookingState bookingState = state;
    if (currentUserBloc.state is CurrentUserRetrieveSuccessful &&
        bookingState is BookingLoadedState) {
      emit(const BookingLoadingState());
      try {
        var user =
            (currentUserBloc.state as CurrentUserRetrieveSuccessful).user;
        var botTOken = dotenv.env['TELEGRAM_BOOKING_TOKEN'].toString();
        var chatID = dotenv.env['TELEGRAM_BOOKING_CHAT_ID'].toString();
        final username = (await Telegram(botTOken).getMe()).username;
        var teledart = TeleDart(botTOken, Event(username!));

        //Prepare booking text
        String bookingText =
            "\nИмя: ${user.name}\nТелефон: ${user.phoneNumber}\nДата и время бронирования: ${bookingState.selectedBookingDay}, ${bookingState.selectedBookingTime}\nКоличество персон: ${bookingState.numberOfPersons}\n\nДополнительные комментарии:\n${comments.trim()}";

        await teledart.sendMessage(chatID, bookingText);
        emit(BookingSuccessDelivery());
      } catch (e) {
        emit(BookingErrorState(e.toString()));
      }
    }
  }
}
