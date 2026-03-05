import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../FirebaseServices/google_sign_in.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), // لازم email
        password: passwordController.text.trim(),
      );

      print("Login success: ${credential.user?.email}");

      Navigator.pushReplacementNamed(
        context,
        AppRoute.HomeScreen.name,
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'Email Address'),
          const SizedBox(height: 8),
          AuthTextField(
            keyboardType: TextInputType.name,
            controller: emailController,
            hint: 'Enter your Email Address',
            icon: Icons.email_outlined,
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
            onTogglePassword: () =>
                setState(() => showPassword = !showPassword),
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
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              var user = await FirestoreServices.signInWithGoogle();
              print(user.user?.displayName);
              print(user.user?.email);
            },
            child: Center(
              child: SvgPicture.asset(
                "assets/auth/google.svg",
                width: 40,
                height: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
