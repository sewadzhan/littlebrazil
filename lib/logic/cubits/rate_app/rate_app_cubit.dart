import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';

part 'rate_app_state.dart';

class RateAppCubit extends Cubit<RateAppState> {
  final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 5,
    remindDays: 7,
    remindLaunches: 3,
    googlePlayIdentifier: 'kz.khan.littlebrazil',
    appStoreIdentifier: '', //CHANGE
  );

  RateAppCubit() : super(RateAppInitial());

  //Show rate app popup
  showRateAppPopup(BuildContext context) {
    var isAndroid = Theme.of(context).platform == TargetPlatform.android;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showStarRateDialog(
          context,
          title: 'Ваше мнение важно для нас!',
          message: 'Если Вам понравилось приложение, пожалуйста оцените его',
          actionsBuilder: (context, stars) {
            return [
              TextButton(
                child: const Text('Оценить'),
                onPressed: () async {
                  if (stars == null || stars == 0) {
                    return;
                  }
                  rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                  if (stars >= 4) {
                    rateMyApp.launchStore();
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.successSnackBar(
                          context, "Спасибо за Вашу оценку",
                          duration: const Duration(milliseconds: 1600)));
                },
              ),
              TextButton(
                child: const Text('Напомнить позже'),
                onPressed: () async {
                  rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
                  Navigator.pop(context);
                },
              )
            ];
          },
          ignoreNativeDialog: isAndroid,
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        );
      }
    });
  }
}
