import 'dart:async';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatProvider extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isResponding = false;

  // ارسال پیام
  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty || _isResponding) return;

    // افزودن پیام کاربر
    _messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    notifyListeners();

    _scrollToBottom();

    // شروع پاسخ چت‌بات با تأخیر طبیعی
    _isResponding = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      _messages.add(ChatMessage(text: _generateResponse(text), isUser: false));
      _isResponding = false;
      notifyListeners();
      _scrollToBottom();
    });
  }

  // شبیه‌سازی پاسخ چت‌بات (می‌تونی بعداً به API وصلش کنی)
  String _generateResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('سلام')) {
      return 'سلام دانی 👋 خوش اومدی!';
    } else if (lower.contains('حالت چطوره')) {
      return 'من عالی‌ام 😄 تو چطوری؟';
    } else if (lower.contains('کمک')) {
      return 'حتماً! بگو در چه زمینه‌ای کمک می‌خوای؟ 🤔';
    } else {
      return '   سلاممم من ویس‌کو هستم, دستیار هوشمند, چطور می‌تونم کمکت کنم؟ ';
    }
  }

  // اسکرول خودکار به پایین
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
