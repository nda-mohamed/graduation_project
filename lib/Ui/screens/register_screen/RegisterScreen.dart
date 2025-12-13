import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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

  void _handleRegister() {
    print('Register: ${emailController.text}');
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
            controller: emailController,
            hint: 'Enter your Email Address',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 8),
          const FieldLabel(label: 'User Name'),
          const SizedBox(height: 8),
          AuthTextField(
            controller: usernameController,
            hint: 'Enter your User name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 8),
          const FieldLabel(label: 'Password'),
          const SizedBox(height: 8),
          AuthTextField(
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