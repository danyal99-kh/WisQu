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

  String? _currentChatId;
  String? get currentChatId => _currentChatId;

  bool _isResponding = false;
  bool get isResponding => _isResponding;
  bool _isDisposed = false;

  // اسکرول هوشمند (مثل ChatGPT: فقط وقتی کاربر نزدیک پایین باشه)
  void scrollToBottom({bool force = false}) {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final position = scrollController.position;
      final max = position.maxScrollExtent;
      final current = position.pixels;
      final distance = max - current;

      // اگر کاربر نزدیک پایین باشه یا force باشه → اسکرول کن
      if (force || distance < 300) {
        scrollController.animateTo(
          max,
          duration: Duration(
            milliseconds: (distance * 0.6).clamp(200, 500).toInt(),
          ),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void startNewChat() {
    // اگر چت فعلی پیام داره → lastUpdated آپدیت کن
    if (_currentChatId != null && _messages.isNotEmpty) {
      final current = _getCurrentChatSession();
      if (current != null) {
        current.lastUpdated = DateTime.now();
      }
    }

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = ChatSession(
      id: newId,
      title: "چت جدید", // بهتر از "New Chat"
      messages: [],
      lastUpdated: DateTime.now(),
    );

    _chatHistory.insert(0, newSession); // جدیدترین همیشه اول
    _currentChatId = newId;
    _messages.clear();
    textController.clear();

    _sortChatHistory();
    notifyListeners();

    // اسکرول به بالا بعد از ساخت چت جدید
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(0);
    });
  }

  void sendMessage({VoidCallback? onNewBotMessage}) {
    final text = textController.text.trim();
    if (text.isEmpty || _isResponding) return;

    // اگر چت فعلی وجود نداره → اول بساز
    if (_currentChatId == null) {
      startNewChat();
    }

    final userMessage = ChatMessage(text: text, isUser: true);
    _messages.add(userMessage);

    final currentSession = _getCurrentChatSession()!;
    currentSession.messages.add(userMessage);

    textController.clear();

    // عنوان چت با اولین پیام کاربر تنظیم بشه
    if (currentSession.messages.length == 1) {
      currentSession.title = text.length > 50
          ? '${text.substring(0, 47)}...'
          : text;
    }

    currentSession.lastUpdated = DateTime.now();
    _sortChatHistory();

    notifyListeners();
    scrollToBottom(force: true); // پیام کاربر حتماً دیده بشه

    // شبیه‌سازی پاسخ بات
    _isResponding = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      // چک کن پراوایدر هنوز زنده باشه
      if (_isDisposed) return;

      final response = _generateResponse(text);
      final botMessage = ChatMessage(text: response, isUser: false);

      _messages.add(botMessage);
      currentSession.messages.add(botMessage);
      currentSession.lastUpdated = DateTime.now();
      _sortChatHistory();

      _isResponding = false;
      notifyListeners();
      scrollToBottom(force: true);
      onNewBotMessage?.call();
    });
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

    // اسکرول به پایین بعد از لود چت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(force: true);
    });
  }

  void togglePinChat(String chatId) {
    final chat = _chatHistory.firstWhere((c) => c.id == chatId);
    chat.isPinned = !chat.isPinned;
    _sortChatHistory();
    notifyListeners();
  }

  void renameChat(String chatId, String newTitle) {
    final chat = _chatHistory.firstWhere((c) => c.id == chatId);
    chat.title = newTitle.trim().isEmpty ? "چت بدون عنوان" : newTitle;
    notifyListeners();
  }

  void deleteChat(String chatId) {
    _chatHistory.removeWhere((c) => c.id == chatId);

    if (_currentChatId == chatId) {
      _messages.clear();
      _currentChatId = null;

      if (_chatHistory.isNotEmpty) {
        loadChat(_chatHistory.first.id);
      } else {
        startNewChat(); // اگر آخرین چت حذف شد → چت جدید بساز
      }
    }

    notifyListeners();
  }

  void clearAllHistory() {
    _chatHistory.clear();
    _messages.clear();
    _currentChatId = null;
    textController.clear();
    startNewChat(); // یه چت خالی جدید
    notifyListeners();
  }

  void _sortChatHistory() {
    _chatHistory.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.lastUpdated.compareTo(a.lastUpdated);
    });
  }

  ChatSession? _getCurrentChatSession() {
    if (_currentChatId == null) return null;
    return _chatHistory.firstWhere((c) => c.id == _currentChatId);
  }

  String _generateResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('سلام') || lower.contains('درود')) {
      return 'سلام! چطور می‌تونم کمکت کنم؟ 😊';
    }
    if (lower.contains('حالت چطوره') || lower.contains('چطور')) {
      return 'عالی‌ام! ممنون که پرسیدی، تو چطوری؟';
    }
    if (lower.contains('کمک') || lower.contains('سوال')) {
      return 'حتماً! بپرس، در خدمتم.';
    }
    return 'جالب بود! ادامه بده یا سوال دیگه‌ای داری؟';
  }

  @override
  void dispose() {
    _isDisposed = true;
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
