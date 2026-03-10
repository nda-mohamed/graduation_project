import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Ui/screens/home_screen/HomeScreen.dart';
import 'Ui/screens/auth_screen/AuthScreen.dart';
import 'Ui/screens/login_screen/LoginScreen.dart';
import 'Ui/screens/onboarding_screen/onBoardingScreen.dart';
import 'Ui/screens/register_screen/RegisterScreen.dart';
import 'core/app_theme/AppTheme.dart';
import 'core/routes/AppRoutes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); /////////////////////

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGRINOVA',
      theme: ThemeData.dark(),

      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,

      initialRoute: AppRoute.onBoardingScreen.name,
      routes: {
        AppRoute.onBoardingScreen.name: (_) => onBoardingScreen(),
        AppRoute.AuthScreen.name: (_) => AuthScreen(),
        AppRoute.LoginScreen.name: (_) => LoginScreen(),
        AppRoute.RegisterScreen.name: (_) => RegisterScreen(),
        AppRoute.HomeScreen.name: (_) => HomeScreen(),
      },
    );
  }
}
