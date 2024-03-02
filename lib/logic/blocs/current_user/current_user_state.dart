part of 'current_user_bloc.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object> get props => [];
}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserRetrieveSuccessful extends CurrentUserState {
  final RestaurantUser user;

  const CurrentUserRetrieveSuccessful(this.user);

  @override
  List<Object> get props => [user];
}

class CurrentUserRetrieveFailure extends CurrentUserState {}
