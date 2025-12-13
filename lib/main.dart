import 'package:flutter/material.dart';
import 'Ui/screens/login_screen/LoginScreen.dart';
import 'Ui/screens/onboarding_screen/onBoardingScreen.dart';
import 'Ui/screens/onboarding_screen/splash_screen/splashScreen.dart';
import 'Ui/screens/register_screen/RegisterScreen.dart';
import 'core/routes/AppRoutes.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Call init before using Rive.
  await RiveNative.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgreVerse',
      theme: ThemeData.dark(),

      initialRoute: AppRoute.onBoardingScreen.name,
      routes: {
        //AppRoute.splashScreen.name: (_) => splashScreen(),
        AppRoute.onBoardingScreen.name: (_) => onBoardingScreen(),
        AppRoute.LoginScreen.name: (_) => LoginScreen(),
        AppRoute.RegisterScreen.name: (_) => RegisterScreen(),
      },
    );
  }
}
