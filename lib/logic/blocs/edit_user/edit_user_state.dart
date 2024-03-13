part of 'edit_user_bloc.dart';

abstract class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object?> get props => [];
}

class UserEditInitial extends EditUserState {}

class UserEditSuccessful extends EditUserState {
  final RestaurantUser user;

  const UserEditSuccessful(this.user);

  @override
  List<Object> get props => [user];
}

class UserEditFailure extends EditUserState {
  final String message;

  const UserEditFailure(this.message);

  @override
  List<Object> get props => [message, Random().nextInt(100)];
}
