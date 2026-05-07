import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/ai/plant_disease_model.dart';
import '../../../../core/api/disease_api_service.dart';
import '../../../../core/app_theme/AppColors.dart';
import '../../../../core/repository/disease_repository.dart';
import 'DetailsScreen.dart';

class CameraScreen extends StatefulWidget {

  final File image;

  const CameraScreen({super.key, required this.image});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  DiseaseRepository repo = DiseaseRepository(DiseaseApiService());

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    analyze();
  }

  Future analyze() async {
    await Future.delayed(const Duration(seconds: 2));

    var result = await repo.detectDisease(widget.image);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(
          image: widget.image,
          result: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [

          /// الصورة
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),

          /// خط الاسكان
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {

              return Positioned(
                top: controller.value *
                    MediaQuery.of(context).size.height,

                left: 0,
                right: 0,

                child: Container(
                  height: 3,
                  color: Colors.greenAccent,
                ),
              );
            },
          ),

          /// النص
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Scanning Leaf...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}