import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:littlebrazil/view/config/app_route.dart';
import 'package:littlebrazil/view/config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // To load the .env file contents into dotenv.
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Brazil',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: '/auth', //isAuthenticated ? '/' : '/auth',
    );
  }
}
