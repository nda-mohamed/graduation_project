import 'package:flutter/material.dart';
import 'DetailsScreen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// الإطار الأبيض
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

          /// زرار التحليل
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailsScreen()),
                );
              },
              child: const Text("Analyze"),
            ),
          ),
        ],
      ),
    );
  }
}
