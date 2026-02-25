import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;
  const RegisterScreen({Key? key, this.onRegisterSuccess}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool acceptTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("User created: ${credential.user?.email}");


      widget.onRegisterSuccess?.call();

    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already exists';
      } else {
        message = e.message ?? 'Registration failed';
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
          const FieldLabel(label: 'Email Address'),
          const SizedBox(height: 8),
          AuthTextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            hint: 'Enter your Email Address',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
          const FieldLabel(label: 'Confirm Password'),
          const SizedBox(height: 8),
          AuthTextField(
            keyboardType: TextInputType.visiblePassword,
            controller: confirmPasswordController,
            hint: 'Enter your Confirm Password',
            icon: Icons.lock_outline,
            isPassword: true,
            showPassword: showConfirmPassword,
            onTogglePassword: () => setState(() => showConfirmPassword = !showConfirmPassword),
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
                      value: acceptTerms,
                      onChanged: (value) => setState(() => acceptTerms = value!),
                      fillColor: MaterialStateProperty.all(Colors.transparent),
                      checkColor: AppColor.green6,
                      side: const BorderSide(color: AppColor.green6, width: 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Creating Account With Accepting Terms & Conditions',
                    style: TextStyle(color: AppColor.green6, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          AuthButton(text: 'Register', onPressed: _handleRegister),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}