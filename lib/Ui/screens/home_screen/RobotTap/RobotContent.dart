import 'package:flutter/material.dart';
import 'package:graduation_project/Ui/screens/home_screen/RobotTap/chatBot/ChatBot.dart';
import 'package:graduation_project/core/app_theme/app_images.dart';
import '../../../../core/app_theme/AppColors.dart';

class RobotContent extends StatelessWidget {
  const RobotContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        title: Text(
          "Robot",
          style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: ImageIcon(AssetImage(AppImage.chatbot)),
            color: AppColor.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBot()),
              );
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
