import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.login_background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Welcome To AGROVA!",
                  style: TextStyle(
                    color: AppColor.green6,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
