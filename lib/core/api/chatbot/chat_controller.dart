import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'chatbot_api_service.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.askAI(text);

      messages.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: "Error: $e", isUser: false));
    }

    isLoading = false;
    notifyListeners();
  }
}