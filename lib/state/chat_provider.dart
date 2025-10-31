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

  // فقط یک تابع اسکرول: نرم، هوشمند و بدون تکون
  void scrollToBottom() {
    // صبر تا بعد از رندر فریم (بهترین روش)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final maxExtent = scrollController.position.maxScrollExtent;
      final current = scrollController.offset;
      final distance = maxExtent - current;

      // فقط اگر فاصله بیشتر از 100 پیکسل باشه، اسکرول کن
      if (distance > 100) {
        scrollController.animateTo(
          maxExtent,
          duration: Duration(
            milliseconds: (distance * 0.8).clamp(200, 400).toInt(),
          ),
          curve: Curves.easeOutCubic,
        );
      } else if (distance > 0) {
        // اسکرول خیلی کوتاه → خیلی نرم
        scrollController.animateTo(
          maxExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ارسال پیام
  void sendMessage({VoidCallback? onNewBotMessage}) {
    final text = textController.text.trim();
    if (text.isEmpty || _isResponding) return;

    // افزودن پیام کاربر
    _messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    notifyListeners();

    // اسکرول نرم بعد از اضافه شدن پیام کاربر
    scrollToBottom();

    // شبیه‌سازی پاسخ بات
    _isResponding = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      _messages.add(ChatMessage(text: _generateResponse(text), isUser: false));
      _isResponding = false;
      notifyListeners();

      // اسکرول نرم بعد از پاسخ بات
      scrollToBottom();

      // انیمیشن پیام جدید
      onNewBotMessage?.call();
    });
  }

  String _generateResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('سلام')) {
      return 'سلام جناب خوش اومدی!';
    } else if (lower.contains('حالت چطوره')) {
      return 'من عالی‌ام تو چطوری؟';
    } else if (lower.contains('کمک')) {
      return 'حتماً! بگو در چه زمینه‌ای کمک می‌خوای؟';
    } else {
      return 'سلاممم من ویس‌کو هستم, دستیار هوشمند, چطور می‌تونم کمکت کنم؟';
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
