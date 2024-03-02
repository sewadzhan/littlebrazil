part of 'current_user_bloc.dart';

abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}

//Событие на получение данных текущего пользователя из Firebase
class CurrentUserRetrieved extends CurrentUserEvent {
  final String phoneNumber;

  const CurrentUserRetrieved(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

//Переназначение текущего пользователя после редактирования для того, чтобы не считывать из Firebase
class CurrentUserSet extends CurrentUserEvent {
  final RestaurantUser user;

  const CurrentUserSet(this.user);
}

//Change user cashback in Profile Screen
class CurrentUserCashbackChanged extends CurrentUserEvent {
  final int cashback;

  const CurrentUserCashbackChanged(this.cashback);

  @override
  List<Object> get props => [cashback];
}

//Current user signed out
class CurrentUserSignedOut extends CurrentUserEvent {}

//Delete personal information of current user
class CurrentUserRemoved extends CurrentUserEvent {}
