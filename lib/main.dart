import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:littlebrazil/data/providers/auth_firebase_provider.dart';
import 'package:littlebrazil/data/repositories/auth_repository.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/view/config/app_route.dart';
import 'package:littlebrazil/view/config/theme.dart';

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

  final AuthRepository authRepository =
      AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance));
  final AuthCubit authBloc = AuthCubit(authRepository);
  // final NotificationBloc notificationBloc = NotificationBloc()
  //   ..add(InitializeNotificationEvent());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => authBloc,
      ),
      BlocProvider(
        create: (context) => authBloc, //remove
      ),
      // BlocProvider(
      //   create: (context) => notificationBloc,
      // ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var isAuthenticated = context.read<AuthCubit>().state != null;

    return MaterialApp(
      title: 'Little Brazil',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: isAuthenticated ? '/' : '/auth',
    );
  }
}
