import 'package:flutter/material.dart';
import '../../../../core/app_theme/AppColors.dart';
import '../../../../core/app_theme/app_images.dart';
import '../RobotTap/chatBot/ChatBot.dart';

class DroneContent extends StatelessWidget {
  const DroneContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        title: Text(
          "Drone",
          style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: ImageIcon(AssetImage(AppImage.chatbot)),
            color: AppColor.white,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ChatBot()),
              // );
            },
          ),
          IconButton(
            icon: ImageIcon(AssetImage(AppImage.alert)),
            color: AppColor.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

