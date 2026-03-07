import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/app_theme/AppColors.dart';

class DetailsScreen extends StatelessWidget {
  final File image;
  final List result;

  const DetailsScreen({super.key, required this.image, required this.result});

  @override
  Widget build(BuildContext context) {
    // 3 أصناف فقط حسب الموديل
    List diseases = [
      "Healthy",
      "Powdery Mildew",
      "Leaf Rust"
    ];

    // ✅ تحويل result لكل العناصر لـ double
    List<double> output = result.map((e) => (e as num).toDouble()).toList();

    // index لأعلى قيمة
    int index = output.indexWhere((e) => e == output.reduce((a, b) => a > b ? a : b));
    String diseaseName = diseases[index];

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // صورة النبات
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(image),
            ),

            const SizedBox(height: 20),

            const Text(
              "Detection Result",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.green5.withOpacity(.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Disease: $diseaseName",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Confidence: ${(output[index] * 100).toStringAsFixed(2)} %",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}