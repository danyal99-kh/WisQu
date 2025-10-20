import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatProvider extends ChangeNotifier {
  // کنترلر TextField
  final TextEditingController textController = TextEditingController();

  // لیست پیام‌ها
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  // ارسال پیام
  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // اضافه کردن پیام کاربر
    _messages.add(ChatMessage(text: text, isUser: true));

    // پاک کردن TextField
    textController.clear();

    // می‌تونیم اینجا پیام چت بات رو هم اضافه کنیم (فعلا یک پاسخ نمونه)
    _messages.add(ChatMessage(text: "سلام! من چت بات هستم.", isUser: false));

    notifyListeners(); // آپدیت UI
  }
}
