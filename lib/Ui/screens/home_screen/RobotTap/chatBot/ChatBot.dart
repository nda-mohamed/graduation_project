import 'package:flutter/material.dart';
import 'package:graduation_project/core/app_theme/app_images.dart';
import '../../../../../core/app_theme/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;
  final ScrollController _scrollController = ScrollController();

  final CollectionReference chatCollection =
  FirebaseFirestore.instance.collection('farmer_chats');

  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String message = _controller.text.trim();
    _controller.clear();

    await chatCollection.add({
      'sender': 'user',
      'text': message,
      'timestamp': Timestamp.now(),
    });

    final botReply = await _getGPTResponse(message);

    await chatCollection.add({
      'sender': 'bot',
      'text': botReply,
      'timestamp': Timestamp.now(),
    });

    // تمرير تلقائي للأسفل بعد إرسال أي رسالة
    _scrollToBottom();
  }

  Future<String> _getGPTResponse(String userMessage) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions"); //////////////
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4.1-mini",
        "messages": [
          {"role": "system", "content": "You are an AI assistant for farmers."},
          {"role": "user", "content": userMessage},
        ],
        "max_tokens": 200
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "Error: ${response.body}";
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
        centerTitle: true,
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
                              color: isUser ? AppColor.white : AppColor.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(height: 2, color: AppColor.white),
          const SizedBox(height: 12),

          // حقل الكتابة + زر الإرسال + زر التسجيل الصوتي
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColor.gray3,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColor.gray,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.green6, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(color: AppColor.gray2),
                            decoration: const InputDecoration(
                              hintText: "Ask a question...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: AppColor.green8),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                GestureDetector(
                  onLongPressStart: (_) => setState(() => _isRecording = true),
                  onLongPressEnd: (_) => setState(() => _isRecording = false),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? AppColor.green8 : AppColor.rec,
                    ),
                    child: ClipOval(
                      child: Image.asset(AppImage.rec),
                    ),
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