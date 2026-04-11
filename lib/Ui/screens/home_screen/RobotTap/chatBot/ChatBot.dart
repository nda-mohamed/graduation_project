import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";

  @override
  void initState() {
    super.initState();
    _loadModel();
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

  Future<void> _loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/models/DD/plant_disease_model_cnn.tflite',
    );
    print("TFLite model loaded!");
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || apiKey.isEmpty) return;

    String message = _controller.text.trim();
    _controller.clear();

    await chatCollection.add({
      'sender': 'user',
      'text': message,
      'timestamp': Timestamp.now(),
    });

    final typingDoc = await chatCollection.add({
      'sender': 'bot',
      'text': 'Typing...',
      'timestamp': Timestamp.now(),
    });

    // لو الرسالة فيها plant/leaf → نطلب صورة
    if (message.toLowerCase().contains("leaf") ||
        message.toLowerCase().contains("plant") ||
        message.toLowerCase().contains("disease")) {
      await typingDoc.update({
        'text': "Please upload an image of the plant 🌱",
      });
      _scrollToBottom();
      return;
    }

    // 👇 الردود الخاصة بالأبلكيشن
    String? localResponse = _getAppHelpResponse(message);

    if (localResponse != null) {
      await typingDoc.update({'text': localResponse});
      _scrollToBottom();
      return;
    }

    // 👇 لو مش سؤال خاص → GPT
    final botReply = await _getGPTResponse(message);

    await typingDoc.update({'text': botReply});
    await flutterTts.speak(botReply);
    _scrollToBottom();
  }

  Future<String> _getGPTResponse(String userMessage) async {
    try {
      final url = Uri.parse("https://api.openai.com/v1/chat/completions");

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $apiKey",
            },
            body: jsonEncode({
              "model": "gpt-4.1-mini",
              "messages": [
                {
                  "role": "system",
                  "content": "You are an AI assistant for AGRINOVA app. "
                      "Help users use the app, upload images, "
                      "detect plant diseases, and give agricultural advice.",
                },
                {"role": "user", "content": userMessage},
              ],
              "max_tokens": 200,
            }),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception("Request timed out");
            },
          );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].toString().trim();
        } else {
          return "No response from AI.";
        }
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage = File(picked.path);
      await chatCollection.add({
        'sender': 'user',
        'text': '[Image]',
        'timestamp': Timestamp.now(),
      });
      _analyzeImage(selectedImage!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    // هنا لازم تحولي الصورة للـ input المناسب للموديل
    // resize + normalize حسب الموديل
    var input = []; // TODO: استبدلي بالمعالجة الحقيقية
    var output = List.filled(1 * 10, 0).reshape([1, 10]); // عدد الكلاسات

    interpreter.run(input, output);

    int predictedIndex = output[0].indexOf(
      output[0].reduce((a, b) => a > b ? a : b),
    );
    String disease = _getDiseaseName(predictedIndex);

    await chatCollection.add({
      'sender': 'bot',
      'text': "Detected: $disease 🌱",
      'timestamp': Timestamp.now(),
    });

    final advice = await _getGPTResponse(
      "Give treatment for $disease in plants",
    );

    await chatCollection.add({
      'sender': 'bot',
      'text': advice,
      'timestamp': Timestamp.now(),
    });

    _scrollToBottom();
  }

  String _getDiseaseName(int index) {
    List<String> diseases = [
      "Early Blight",
      "Late Blight",
      "Healthy",
      "Leaf Spot",
      "Powdery Mildew",
      // عدلي حسب الكلاسات عندك
    ];
    return diseases[index];
  }

  String? _getAppHelpResponse(String message) {
    message = message.toLowerCase();

    if (message.contains("how to use") || message.contains("use app")) {
      return "📱 To use the app:\n\n"
          "1. Ask questions in chat 💬\n"
          "2. Upload plant images using + 📸\n"
          "3. Detect diseases 🌱\n"
          "4. Get treatment advice\n\n"
          "Enjoy using AGRINOVA 💚";
    }

    if (message.contains("upload") || message.contains("image")) {
      return "📸 To upload an image:\n\n"
          "Click + → Choose Gallery or Camera → Select image";
    }

    if (message.contains("camera")) {
      return "📷 You can use the camera from the + button.";
    }

    if (message.contains("chat") || message.contains("ask")) {
      return "💬 You can ask any agricultural question!";
    }

    return null;
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
                          onPressed: _sendMessage,
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