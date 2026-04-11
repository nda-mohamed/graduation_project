import 'package:flutter/material.dart';
import '../../../../core/app_theme/AppColors.dart';
import '../../../../core/widgets/robot/common_widgets/CommonWidgets.dart';

class ViewDetailsScreen extends StatelessWidget {
  const ViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Overview',
            style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Soil Moisture',
                    value: '65%',
                    icon: Icons.water_drop_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Temperature',
                    value: '28°C',
                    icon: Icons.thermostat_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SectionCard(
              title: 'NPK Levels',
              child: const Text(
                '12-8-10',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white),
              ),
            ),
            const SizedBox(height: 12),

            TrendCard(
              label: 'Moisture Trend',
              badge: 'Last 7 Days  +5%',
              value: '+5%',
              valueColor: AppColor.green,
              lineColor: AppColor.green,
              points: const [30, 20, 28, 10, 22, 15, 18],
            ),
            const SizedBox(height: 12),

            TrendCard(
              label: 'Moisture Trend',
              badge: 'Last 7 Days  -2%',
              value: '-2%',
              valueColor: AppColor.red,
              lineColor: AppColor.red,
              points: const [20, 30, 15, 35, 12, 28, 22],
            ),
            const SizedBox(height: 12),

            const SectionLabel(label: 'Field Status'),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                width: double.infinity,
                color: const Color(0xFF2A4A2A),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 140),
                      painter: FakeMapPainter(),
                    ),
                    const Center(
                      child: Icon(Icons.location_on,
                          color: AppColor.green, size: 36),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            const SectionLabel(label: 'AI Insights'),
            const SizedBox(height: 8),
            InsightCard(
              title: 'Irrigation Optimization',
              subtitle: 'AI suggests reducing irrigation by 15%',
              icon: Icons.water_outlined,
              color: const Color(0xFF1B3A1B),
            ),
            const SizedBox(height: 10),
            InsightCard(
              title: 'Yield Prediction',
              subtitle: 'AI predicts a 10% yield increase this season',
              icon: Icons.trending_up,
              color: const Color(0xFF1B3A1B),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}