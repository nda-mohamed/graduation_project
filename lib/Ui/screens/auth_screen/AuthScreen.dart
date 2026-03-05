import 'package:flutter/material.dart';
import '../../../core/app_theme/AppColors.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../core/widgets/auth/common_widgets/common_widget.dart';
import '../home_screen/HomeScreen.dart';
import '../login_screen/LoginScreen.dart';
import '../register_screen/RegisterScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onToggle(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const AuthHeader(),
              const SizedBox(height: 32),
              AuthToggleButtons(
                currentIndex: _currentIndex,
                onToggle: _onToggle,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    const LoginScreen(),
                    RegisterScreen(
                      onRegisterSuccess: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
