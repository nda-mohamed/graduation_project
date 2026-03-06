import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/app_theme/AppColors.dart';
import 'CameraScreen.dart';

class DiseaseDetectionContent extends StatefulWidget {
  const DiseaseDetectionContent({super.key});

  @override
  State<DiseaseDetectionContent> createState() => _DiseaseDetectionContentState();
}

class _DiseaseDetectionContentState extends State<DiseaseDetectionContent> {
  File? _imageFile;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      // لو المستخدم ضغط رجوع بدون اختيار صورة
      print('No image selected.');
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CameraScreen(),
                    ),
                  );
                },
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
