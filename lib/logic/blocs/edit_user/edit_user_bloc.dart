import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/restaurant_user.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

//Bloc for editing personal customer's information
class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final FirestoreRepository firestoreRepository;

  EditUserBloc(this.firestoreRepository) : super(UserEditInitial()) {
    on<UserEdited>(userEditedToState);
  }

  userEditedToState(EditUserEvent event, Emitter<EditUserState> emit) async {
    if (event is UserEdited) {
      try {
        validateData(event);
        await firestoreRepository.editUser(event.phoneNumber, event.newData);
        emit(UserEditSuccessful(RestaurantUser(
            phoneNumber: event.phoneNumber,
            name: event.newData["name"],
            email: event.newData["email"],
            birthday: event.newData["birthday"])));
      } catch (e) {
        emit(UserEditFailure(e.toString()));
      }
    }
  }

  validateData(UserEdited event) {
    if (event.newData["name"].toString().isEmpty) {
      throw RestaurantException("Заполните имя");
    } else if (event.newData["name"] == event.oldData["name"] &&
        event.newData["email"] == event.oldData["email"] &&
        event.newData["birthday"] == event.oldData["birthday"]) {
      throw RestaurantException("Измените данные");
    } else if (event.newData["email"].toString().isNotEmpty &&
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(event.newData["email"])) {
      throw RestaurantException("Некорректный email");
    }
  }
}
