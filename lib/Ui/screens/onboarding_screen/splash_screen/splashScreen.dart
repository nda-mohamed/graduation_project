import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduation_project/Ui/screens/onboarding_screen/onBoardingScreen.dart';
import 'package:rive/rive.dart';

class splashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<splashScreen> {
  // FileLoader لتحميل ملف Rive
  late final fileLoader = FileLoader.fromAsset(
    "assets/animations/splash.riv",
    riveFactory: Factory.rive,
  );

  @override
  void initState() {
    super.initState();

    // الانتقال للـ Onboarding بعد 3 ثواني
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                onBoardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // تنظيف الموارد
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF112117),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rive Animation مع RiveWidgetBuilder
              SizedBox(
                width: 350,
                height: 350,
                child: RiveWidgetBuilder(
                  fileLoader: fileLoader,
                  builder: (context, state) => switch (state) {
                    // حالة التحميل
                    RiveLoading() => Center(
                      child: CircularProgressIndicator(
                        color: Colors.green.shade300,
                      ),
                    ),

                    // حالة الخطأ
                    RiveFailed() => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade300,
                            size: 60,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Failed to load animations',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    // حالة النجاح - عرض الـ Animation
                    RiveLoaded() => RiveWidget(
                      controller: state.controller,
                      fit: Fit.contain,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
