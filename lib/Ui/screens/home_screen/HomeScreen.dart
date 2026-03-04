import 'package:flutter/material.dart';
import '../../../core/app_theme/app_images.dart';
import '../../../core/app_theme/AppColors.dart';
import 'DiesaeseDetectionTap/DeseaseDetectionContent.dart';
import 'DroneTap/DroneContent.dart';
import 'ProfileTap/ProfileContent.dart';
import 'RobotTap/RobotContent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTapIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: tabs[selectedTapIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTapIndex,
        onTap: (index) {
          setState(() {
            selectedTapIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColor.background,
            icon: ImageIcon(AssetImage(AppImage.robot)),
            label: 'Robot',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.background,
            icon: ImageIcon(AssetImage(AppImage.drone)),
            label: 'Drone',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.background,
            icon: ImageIcon(AssetImage(AppImage.disease_detection)),
            label: 'Disease\nDetection',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColor.background,
            icon: ImageIcon(AssetImage(AppImage.profile)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Widget> tabs = [
    RobotContent(),
    DroneContent(),
    DiseaseDetectionContent(),
    ProfileContent(),
  ];
}
