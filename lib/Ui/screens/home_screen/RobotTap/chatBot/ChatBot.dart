import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graduation_project/core/app_theme/AppColors.dart';
import 'package:graduation_project/core/app_theme/app_images.dart';

import '../../../../../core/api/chatbot/chat_provider.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
    final provider = Provider.of<ChatProvider>(context);

    /// ✅ Auto scroll after every rebuild (important fix)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

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
          /// 💬 CHAT
          Expanded(
            child: provider.messages.isEmpty
                ? Center(
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
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount:
                        provider.messages.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      /// 🟡 Loading indicator improved UX
                      if (index == provider.messages.length &&
                          provider.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                CircularProgressIndicator(strokeWidth: 2),
                                SizedBox(width: 10),
                                Text(
                                  "AI is thinking...",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final msg = provider.messages[index];

                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),

                          /// ⭐ WhatsApp style bubbles
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? AppColor.green8
                                : const Color(0xFF243134),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                              bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                            ),
                          ),

                          child: Text(
                            msg.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Container(height: 1, color: AppColor.white),

          const SizedBox(height: 12),

          /// ✍️ INPUT (UNCHANGED UI)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF243134),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColor.green8),

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

                        IconButton(
                          icon: Icon(Icons.send, color: AppColor.green8),

                          /// 🟡 FIX: prevent empty messages
                          onPressed: () async {
                            final text = _controller.text.trim();
                            if (text.isEmpty) return;

                            _controller.clear();

                            await provider.sendMessage(text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.rec,
                  ),
                  child: ClipOval(child: Image.asset(AppImage.rec)),
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
