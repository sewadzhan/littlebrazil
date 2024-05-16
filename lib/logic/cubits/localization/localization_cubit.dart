import 'dart:developer';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'localization_state.dart';

//Cubit for app's localization
class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(const LocalizationState(locale: Locale('ru'))) {
    getLocale();
  }

  //Get saved locale from shared preferences
  void getLocale() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final String? currentLocale = preferences.getString('locale');
      if (currentLocale != null) {
        emit(LocalizationState(locale: Locale(currentLocale)));
      }
    } catch (e) {
      log("Localization Cubit Error: $e");
    }
  }

  //Save new user's locale in shared preferences
  void setLocale(Locale newLocale) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString('locale', newLocale.languageCode);
      emit(LocalizationState(locale: newLocale));
    } catch (e) {
      log("Localization Cubit Error: $e");
    }
  }
}
