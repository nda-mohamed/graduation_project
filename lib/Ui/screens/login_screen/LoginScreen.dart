import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';
import '../home_screen/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool showPassword = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: usernameController.text.trim(), // لازم email
        password: passwordController.text.trim(),
      );

      print("Login success: ${credential.user?.email}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String message = '';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      } else {
        message = e.message ?? 'Login failed';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'User Name'),
          const SizedBox(height: 8),
          AuthTextField(
            keyboardType: TextInputType.name,
            controller: usernameController,
            hint: 'Enter your User name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 8),
          const FieldLabel(label: 'Password'),
          const SizedBox(height: 8),
          AuthTextField(
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            hint: 'Enter your Password',
            icon: Icons.lock_outline,
            isPassword: true,
            showPassword: showPassword,
            onTogglePassword: () => setState(() => showPassword = !showPassword),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (value) => setState(() => rememberMe = value!),
                      fillColor: MaterialStateProperty.all(Colors.transparent),
                      checkColor: AppColor.green6,
                      side: const BorderSide(color: AppColor.green6, width: 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(color: AppColor.green6, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          AuthButton(text: 'Login', onPressed: _handleLogin),
        ],
      ),
    );
  }
}
