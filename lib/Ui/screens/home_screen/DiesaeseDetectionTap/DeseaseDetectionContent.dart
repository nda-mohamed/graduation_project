import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/Ui/screens/home_screen/DiesaeseDetectionTap/CameraScreen.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ai/plant_disease_model.dart';
import '../../../../core/app_theme/AppColors.dart';

class DiseaseDetectionContent extends StatefulWidget {
  const DiseaseDetectionContent({super.key});

  @override
  State<DiseaseDetectionContent> createState() => _DiseaseDetectionContentState();
}

class _DiseaseDetectionContentState extends State<DiseaseDetectionContent> {

  PlantDiseaseModel model = PlantDiseaseModel();

  @override
  void initState() {
    super.initState();
    model.loadModel();
  }

  // اختيار صورة من المعرض
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      print("✅ Image selected: ${image.path}");

      // فتح شاشة Scan مباشرة بعد اختيار الصورة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CameraScreen(image: image),
        ),
      );

    } else {
      print('No image selected.');
    }
  }

  // فتح الكاميرا مباشرة
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      print("✅ Photo taken: ${image.path}");

      // فتح شاشة Scan مباشرة بعد التقاط الصورة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CameraScreen(image: image),
        ),
      );

    } else {
      print('No photo taken.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.greenDP,
              ),
              child: Icon(Icons.add_rounded, color: AppColor.white, size: 50),
            ),

            const SizedBox(height: 30),

            const Text(
              "Identify Crop Diseases",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              "Capture or upload an image of the affected\ncrop leaf for an instant AI-powered analysis.",
              style: TextStyle(color: AppColor.gray, fontSize: 14),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // زرار الكاميرا
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.greenTP,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _takePhoto,
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColor.black,
                  size: 20,
                ),
                label: const Text(
                  "Take Photo",
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // زرار رفع من المعرض
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.greenU,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _pickImageFromGallery,
                icon: const Icon(
                  Icons.file_upload_outlined,
                  color: AppColor.white,
                  size: 20,
                ),
                label: const Text(
                  "Upload from Gallery",
                  style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}