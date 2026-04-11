import 'package:flutter/material.dart';
import 'package:graduation_project/core/app_theme/app_images.dart';
import '../../../../core/app_theme/AppColors.dart';
import '../../../../core/widgets/robot/common_widgets/CommonWidgets.dart';
import 'ViewDetailsScreen.dart';

class RobotContent extends StatelessWidget {
  const RobotContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        title: const Text(
          'Robot',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: ImageIcon(AssetImage(AppImage.chatbot)),
            color: AppColor.white,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => ChatBot()),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBanner(
              onViewDetails: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ViewDetailsScreen()),
              ),
            ),

            const SizedBox(height: 12),

            SectionCard(
              title: 'Yield Forecast',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Predicted Yield',
                    style: TextStyle(
                      color: AppColor.gray,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        '1200',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Next 3 Months  +15%',
                          style: TextStyle(color: AppColor.green, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  MiniLineChart(color: AppColor.green5),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Month 1',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.gray,
                        ),
                      ),
                      Text(
                        'Month 2',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.gray,
                        ),
                      ),
                      Text(
                        'Month 3',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SectionCard(
              title: 'Nutrient Levels',
              child: const Column(
                children: [
                  NutrientBar(
                    label: 'Nitrogen',
                    value: 0.75,
                    display: '75 ppm',
                  ),
                  SizedBox(height: 10),
                  NutrientBar(
                    label: 'Phosphorus',
                    value: 0.60,
                    display: '60 ppm',
                  ),
                  SizedBox(height: 10),
                  NutrientBar(
                    label: 'Potassium',
                    value: 0.80,
                    display: '80 ppm',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SectionCard(
              title: 'Stress Indicators',
              child: const Column(
                children: [
                  NutrientBar(
                    label: 'Water Stress',
                    value: 0.20,
                    display: '20 %',
                  ),
                  SizedBox(height: 10),
                  NutrientBar(
                    label: 'Heat Stress',
                    value: 0.10,
                    display: '10 %',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}