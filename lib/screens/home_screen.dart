// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/getstarted_screens.dart';
import '../../state/chat_provider.dart';
import 'package:wisqu/screens/setting_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // برای کنترل نمایش متن خوشامدگویی
  final ValueNotifier<bool> showWelcomeText = ValueNotifier(true);

  // AnimationController برای پیام‌های جدید
  late final AnimationController _messageAnimController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _messageAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 247, 251),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 AppBar سفارشی
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 237, 242, 248),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(2, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔸 لوگو و نام برنامه فقط وقتی خوشامدگویی محو شد
                  ValueListenableBuilder<bool>(
                    valueListenable: showWelcomeText,
                    builder: (context, isVisible, child) {
                      if (isVisible) {
                        return const SizedBox(); // وقتی خوشامدگویی هست، خالی باشه
                      }
                      return Row(
                        children: [
                          Hero(
                            tag: 'appLogo',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset('assets/logo.png', height: 34),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "WisQu",
                            style: TextStyle(
                              color: Color.fromARGB(255, 72, 72, 72),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // 🔸 آیکون تنظیمات و دکمه Get Started همیشه نمایش داده شود
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        color: const Color.fromARGB(255, 119, 72, 200),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showLoginDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            119,
                            72,
                            200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🔹 لیست پیام‌ها (زیر خوشامدگویی)
                  ListView.builder(
                    controller: chatProvider.scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      final isLastMessage =
                          index == chatProvider.messages.length - 1;

                      // ویجت پیام بدون انیمیشن
                      Widget messageWidget = Column(
                        crossAxisAlignment: message.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: message.isUser
                                    ? const Color.fromRGBO(255, 255, 253, 1)
                                    : const Color.fromARGB(255, 246, 247, 251),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          if (!message.isUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildIconButton(
                                    icon: Icons.thumb_up_alt_outlined,
                                    tooltip: 'Like',
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You liked this response 👍',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildIconButton(
                                    icon: Icons.thumb_down_alt_outlined,
                                    tooltip: 'Dislike',
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You disliked this response 👎',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildIconButton(
                                    icon: Icons.copy,
                                    tooltip: 'Copy',
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: message.text),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Message copied 📋'),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildIconButton(
                                    icon: Icons.sync,
                                    tooltip: 'Regenerate',
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Regenerating response... 🔄',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );

                      // اگر آخرین پیام هست، انیمیشن اضافه کن
                      if (isLastMessage) {
                        _messageAnimController.forward(from: 0);
                        return FadeTransition(
                          opacity: _messageAnimController,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _messageAnimController,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                            child: messageWidget,
                          ),
                        );
                      }

                      return messageWidget; // پیام‌های دیگر بدون انیمیشن
                    },
                  ),

                  // 🔹 متن خوشامدگویی روی لیست (با انیمیشن محو)
                  ValueListenableBuilder<bool>(
                    valueListenable: showWelcomeText,
                    builder: (context, isVisible, child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        opacity: isVisible ? 1.0 : 0.0,
                        curve: Curves.easeInOutCubic,
                        child: IgnorePointer(
                          ignoring: !isVisible, // وقتی محو شد، لمس غیرفعال بشه
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: "appLogo",
                          child: Image.asset(
                            'assets/logo.png',
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.13,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.02,
                          ),
                          child: Text(
                            'WisQu\nHello, What can I help \nyou with?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 72, 72, 72),
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),

            // 🔹 TextField و متن پایین
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 242, 248),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            2,
                            2,
                            2,
                          ).withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(1, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatProvider.textController,
                            minLines: 1,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "What do you want to know?",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 72, 72, 116),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) => setState(() {}),
                          onTapUp: (_) => setState(() {}),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_upward_rounded),
                            color: const Color.fromARGB(255, 119, 72, 200),
                            onPressed: () {
                              chatProvider.sendMessage();

                              // اجرای انیمیشن محو شدن
                              if (showWelcomeText.value) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    showWelcomeText.value = false; // fade-out
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (!keyboardOpen)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: screenHeight * 0.002,
                      ), // خیلی نزدیک به پایین
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth *
                            0.05, // فاصله افقی با توجه به اندازه صفحه
                        vertical: screenHeight * 0.003, // فاصله عمودی متناسب
                      ), // padding کمی برای زیبایی
                      child: Text(
                        "Trained on religious ruling questions. By messaging, you agree to our Terms and Privacy Policy.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(150, 175, 177, 181),
                          fontSize:
                              screenWidth * 0.035, // فونت متناسب با عرض صفحه
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 متد کمکی برای Scale animation روی آیکون‌ها
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) => setState(() {}),
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: const Color.fromARGB(255, 150, 150, 150),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
