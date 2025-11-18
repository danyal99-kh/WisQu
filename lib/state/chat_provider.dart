import 'dart:async';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatSession {
  final String id;
  String title;
  bool isPinned;
  final List<ChatMessage> messages;
  DateTime lastUpdated;

  ChatSession({
    required this.id,
    required this.title,
    this.isPinned = false,
    required this.messages,
    required this.lastUpdated,
  });
}

class ChatProvider extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  final List<ChatSession> _chatHistory = [];
  List<ChatSession> get chatHistory => _chatHistory;
  String? get currentChatId => _currentChatId;
  String? _currentChatId;
  bool _isResponding = false;

  // اسکرول نرم
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final maxExtent = scrollController.position.maxScrollExtent;
      final current = scrollController.offset;
      final distance = maxExtent - current;

      if (distance > 100) {
        scrollController.animateTo(
          maxExtent,
          duration: Duration(
            milliseconds: (distance * 0.8).clamp(200, 400).toInt(),
          ),
          curve: Curves.easeOutCubic,
        );
      } else if (distance > 0) {
        scrollController.animateTo(
          maxExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void startNewChat() {
    // اگه چت فعلی پیام داره، lastUpdated رو آپدیت کن
    if (_currentChatId != null && _messages.isNotEmpty) {
      final current = _getCurrentChatSession();
      if (current != null) {
        current.lastUpdated = DateTime.now();
      }
    }

    // ساخت یه چت جدید با عنوان موقت
    final newChatId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = ChatSession(
      id: newChatId,
      title: "New Chat", // عنوان موقت
      messages: [],
      lastUpdated: DateTime.now(),
    );

    _chatHistory.add(newSession);
    _currentChatId = newChatId;

    // پاک کردن پیام‌های فعلی
    _messages.clear();
    textController.clear();
    scrollController.jumpTo(0);

    _sortChatHistory();
    notifyListeners();
  }

  // ارسال پیام
  void sendMessage({VoidCallback? onNewBotMessage}) {
    final text = textController.text.trim();
    if (text.isEmpty || _isResponding) return;

    final userMessage = ChatMessage(text: text, isUser: true);
    _messages.add(userMessage);

    if (_currentChatId == null) {
      startNewChat();
    }

    final currentSession = _getCurrentChatSession()!;
    currentSession.messages.add(userMessage);

    textController.clear();

    if (currentSession.messages.length == 1) {
      currentSession.title = text.length > 40
          ? '${text.substring(0, 40)}...'
          : text;
    }

    currentSession.lastUpdated = DateTime.now();
    _sortChatHistory();

    notifyListeners();
    scrollToBottom();

    // پاسخ بات
    _isResponding = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      final response = _generateResponse(text);
      final botMessage = ChatMessage(text: response, isUser: false);

      _messages.add(botMessage);
      currentSession.messages.add(botMessage);
      currentSession.lastUpdated = DateTime.now();
      _sortChatHistory();

      _isResponding = false;
      notifyListeners();
      scrollToBottom();
      onNewBotMessage?.call();
    });
  }

  // شروع چت جدید
  void _startNewChat(String firstMessage) {
    final newChat = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: firstMessage.length > 40
          ? '${firstMessage.substring(0, 40)}...'
          : firstMessage,
      messages: [],
      lastUpdated: DateTime.now(),
    );

    _chatHistory.add(newChat);
    _currentChatId = newChat.id;
    _messages.clear();

    _sortChatHistory();
    notifyListeners();
  }

  void loadChat(String chatId) {
    final chat = _chatHistory.firstWhere(
      (c) => c.id == chatId,
      orElse: () => _chatHistory.first,
    );

    _currentChatId = chat.id;
    _messages.clear();
    _messages.addAll(chat.messages);

    notifyListeners();
    scrollToBottom();
  }

  // پین/آنپین
  void togglePinChat(String chatId) {
    final chat = _chatHistory.firstWhere((c) => c.id == chatId);
    chat.isPinned = !chat.isPinned;
    _sortChatHistory(); // همیشه بالا بمونن
    notifyListeners();
  }

  // تغییر نام
  void renameChat(String chatId, String newTitle) {
    final chat = _chatHistory.firstWhere((c) => c.id == chatId);
    chat.title = newTitle.trim().isEmpty ? "Untitled Chat" : newTitle;
    notifyListeners();
  }

  // حذف چت
  void deleteChat(String chatId) {
    _chatHistory.removeWhere((c) => c.id == chatId);
    if (_currentChatId == chatId) {
      clearMessages();
      _currentChatId = null;
      if (_chatHistory.isNotEmpty) {
        loadChat(_chatHistory.first.id);
      }
    }
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void clearAllMessages() {
    _messages.clear();
    _chatHistory.clear();
    _currentChatId = null;
    notifyListeners();
  }

  // مرتب‌سازی هوشمند
  void _sortChatHistory() {
    _chatHistory.sort((a, b) {
      // 1. پین‌شده‌ها همیشه اول
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;

      // 2. بین پین‌شده‌ها: جدیدترین اول
      if (a.isPinned && b.isPinned) {
        return b.lastUpdated.compareTo(a.lastUpdated);
      }

      // 3. بین غیرپین‌شده‌ها: جدیدترین اول
      return b.lastUpdated.compareTo(a.lastUpdated);
    });
  }

  ChatSession? _getCurrentChatSession() {
    if (_currentChatId == null) return null;
    return _chatHistory.firstWhere((c) => c.id == _currentChatId);
  }

  String _generateResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('سلام')) return 'سلام جناب خوش اومدی!';
    if (lower.contains('حالت چطوره')) return 'من عالی‌ام تو چطوری؟';
    if (lower.contains('کمک')) return 'حتماً! بگو در چه زمینه‌ای کمک می‌خوای؟';
    return 'سلاممم من ویس‌کو هستم, دستیار هوشمند, چطور می‌تونم کمکت کنم؟';
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
