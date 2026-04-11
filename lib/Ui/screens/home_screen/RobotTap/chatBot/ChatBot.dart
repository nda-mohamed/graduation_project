import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:graduation_project/core/app_theme/AppColors.dart';
import 'package:graduation_project/core/app_theme/app_images.dart';

import '../../DiesaeseDetectionTap/CameraScreen.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speech = SpeechToText();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  File? selectedImage;
  late Interpreter interpreter;

  final CollectionReference chatCollection = FirebaseFirestore.instance.collection('farmer_chats');
  //final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";

  @override
  void initState() {
    super.initState();
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
        MaterialPageRoute(builder: (_) => CameraScreen(image: image)),
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
        MaterialPageRoute(builder: (_) => CameraScreen(image: image)),
      );
    } else {
      print('No photo taken.');
    }
  }



  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      appBar: AppBar(
        backgroundColor: AppColor.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.green8,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Agricultural Assistant",
          style: TextStyle(
            color: AppColor.green8,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
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
                          child: ClipOval(child: Image.asset(AppImage.lamp)),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "How can I help?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index];
                    final isUser = msg['sender'] == 'user';
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? AppColor.green6 : AppColor.gray3,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: isUser ? AppColor.white : AppColor.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(height: 1, color: AppColor.white),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF243134),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF243134), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        // زر "+" لفتح خيارات الصورة
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: EdgeInsets.all(16),
                                height: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "Upload Image",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _pickImageFromGallery();
                                          },
                                          icon: Icon(Icons.photo),
                                          label: Text("Gallery"),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _takePhoto();
                                          },
                                          icon: Icon(Icons.camera_alt),
                                          label: Text("Camera"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(Icons.add, color: AppColor.green8),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(color: AppColor.gray),
                            decoration: const InputDecoration(
                              hintText: "Ask a question...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          icon: Icon(Icons.send, color: AppColor.green8),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // زر التسجيل الصوتي
                GestureDetector(
                  onLongPressStart: (_) async {
                    bool available = await speech.initialize();
                    if (available) {
                      setState(() => _isRecording = true);
                      speech.listen(
                        onResult: (result) {
                          setState(() {
                            _controller.text = result.recognizedWords;
                          });
                        },
                      );
                    }
                  },
                  onLongPressEnd: (_) {
                    speech.stop();
                    setState(() => _isRecording = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? AppColor.green8 : AppColor.rec,
                    ),
                    child: ClipOval(child: Image.asset(AppImage.rec)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}