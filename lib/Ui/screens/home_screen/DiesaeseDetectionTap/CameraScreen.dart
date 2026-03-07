import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/ai/plant_disease_model.dart';
import 'DetailsScreen.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  PlantDiseaseModel model = PlantDiseaseModel();

  @override
  void initState() {
    super.initState();
    model.loadModel();
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      print("✅ Photo taken: ${image.path}");

      // Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      print("⏳ Running model...");
      var result = model.runModel(image);
      print("✅ Model finished. Result: $result");

      Navigator.pop(context); // close loading

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsScreen(image: image, result: result),
        ),
      );
    } else {
      print("❌ No photo taken.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: _takePhoto,
              child: const Text("Analyze"),
            ),
          ),
        ],
      ),
    );
  }
}