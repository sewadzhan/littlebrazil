import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/data/models/contacts.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';

part 'contacts_state.dart';

//Cubit for contacts screen
class ContactsCubit extends Cubit<ContactsState> {
  final FirestoreRepository firestoreRepository;
  final BottomSheetCubit bottomSheetCubit;
  // final UpdateAppCubit updateAppCubit;
  bool isRestaurantWorking = true;
  ContactsCubit(
    this.firestoreRepository,
    this.bottomSheetCubit, //this.updateAppCubit,
  ) : super(ContactsLoadingState()) {
    getContacts();
  }
  void getContacts() async {
    try {
      final ContactsModel contactsModel =
          await firestoreRepository.getContactsData();
      emit(ContactsLoadedState(contactsModel: contactsModel));

      //After loading playMarketUrl and appStoreUrl check for app updates
      // updateAppCubit.checkNewVersion(
      //     contactsModel.playMarketUrl, contactsModel.appStoreUrl);

      //Check current time if the restaurant is open or not
      checkWorkingTime(contactsModel);
    } catch (e) {
      emit(ContactsErrorState());
    }
  }

  //Check current time if the restaurant is open or not
  void checkWorkingTime(ContactsModel contactsModel) {
    var dateTime = DateTime.now();
    var dateFormat = DateFormat("dd.MM.yyyy HH:mm");
    var dateTimeOpen = dateFormat.parse(
        "${dateTime.day}.${dateTime.month}.${dateTime.year} ${contactsModel.openHour}");
    var dateTimeClose = dateFormat.parse(
        "${dateTime.day}.${dateTime.month}.${dateTime.year} ${contactsModel.closeHour}");

    //Check for close working time is on next day
    if (dateTimeClose.isBefore(dateTimeOpen)) {
      if (dateTime.isAfter(dateTimeClose) && dateTime.isBefore(dateTimeOpen)) {
        isRestaurantWorking = false;
        bottomSheetCubit.showNotWorkingBottomSheet(
            contactsModel.openHour, contactsModel.closeHour);
      }
    } else if (!(dateTime.isAfter(dateTimeOpen) &&
        dateTime.isBefore(dateTimeClose))) {
      isRestaurantWorking = false;
      bottomSheetCubit.showNotWorkingBottomSheet(
          contactsModel.openHour, contactsModel.closeHour);
    }
  }
}
