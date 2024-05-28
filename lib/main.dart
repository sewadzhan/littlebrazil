import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:littlebrazil/logic/blocs/notification/notification_bloc.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/config/app_route.dart';
import 'package:littlebrazil/view/config/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // To load the .env file contents into dotenv.
  await dotenv.load(fileName: ".env");

  //Allowing only vertical orientation of smartphone
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationBloc notificationBloc = NotificationBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalizationCubit(),
        ),
        BlocProvider.value(
          value: notificationBloc,
        ),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, localizationState) {
          return MaterialApp(
            title: 'Little Brazil',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.theme,
            onGenerateRoute: AppRouter().onGenerateRoute,
            locale: localizationState.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}
