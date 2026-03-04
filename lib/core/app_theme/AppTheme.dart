import 'package:flutter/material.dart';
import 'AppColors.dart';

class AppThemes {
  static var darkTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColor.background,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: AppColor.green5,
      unselectedItemColor: AppColor.white,

      selectedIconTheme: const IconThemeData(size: 24),

      unselectedIconTheme: const IconThemeData(size: 24),

      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),

      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
  );
}
