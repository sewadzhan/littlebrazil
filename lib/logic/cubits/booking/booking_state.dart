part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingLoadingState extends BookingState {
  const BookingLoadingState();
}

class BookingLoadedState extends BookingState {
  final String? selectedBookingDay;
  final String? selectedBookingTime;
  final int? numberOfPersons;

  const BookingLoadedState(
      {required this.selectedBookingDay,
      required this.selectedBookingTime,
      required this.numberOfPersons});

  @override
  List<Object?> get props =>
      [selectedBookingDay, selectedBookingTime, numberOfPersons];

  BookingLoadedState copyWith({
    String? selectedBookingDay,
    String? selectedBookingTime,
    String? comments,
    int? numberOfPersons,
  }) {
    return BookingLoadedState(
      selectedBookingDay: selectedBookingDay ?? this.selectedBookingDay,
      selectedBookingTime: selectedBookingTime ?? this.selectedBookingTime,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
    );
  }
}

class BookingErrorState extends BookingState {
  final String message;

  const BookingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingSuccessDelivery extends BookingState {}
