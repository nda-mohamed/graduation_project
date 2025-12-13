import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    print('Login: ${usernameController.text}');
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
