part of 'edit_user_bloc.dart';

abstract class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object> get props => [];
}

//Событие на измнение контактной информации пользователя
class UserEdited extends EditUserEvent {
  final String phoneNumber;
  final Map<String, dynamic> oldData;
  final Map<String, dynamic> newData;

  const UserEdited(
      {required this.phoneNumber,
      required this.oldData,
      required this.newData});

  @override
  List<Object> get props => [phoneNumber, oldData, newData];
}
