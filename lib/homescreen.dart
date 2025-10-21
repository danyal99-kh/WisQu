import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/getstarted.dart';
import '../state/chat_provider.dart';
import 'package:wisqu/setting.dart';

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
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 246, 247, 251),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: IconButton(
              color: const Color.fromARGB(255, 119, 72, 200),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(), // صفحه مقصد
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GetStartedScreen(),
                  ),
                );
              },
              label: const Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 72, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.messages.isEmpty
                ? Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: showWelcomeText,
                      builder: (context, isVisible, child) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: isVisible ? 1.0 : 0.0,
                          curve: Curves.easeInOut,
                          child: child,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/logo.jpg',
                            width: screenWidth * 0.3, // 30% از عرض صفحه
                            height: screenHeight * 0.13, // 15% از ارتفاع صفحه
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1, // 10% از عرض صفحه
                              vertical:
                                  screenHeight * 0.02, // 2% از ارتفاع صفحه
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    screenWidth * 0.1, // 10% از عرض صفحه
                                vertical:
                                    screenHeight * 0.02, // 2% از ارتفاع صفحه
                              ),
                              child: Text(
                                'WisQu\nHello, What can I help \nyou with?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 72, 72, 72),
                                  fontSize:
                                      screenWidth * 0.05, // 5% از عرض صفحه

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: chatProvider.scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      _messageAnimController.forward(
                        from: 0,
                      ); // انیمیشن ورود پیام
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
                          child: Column(
                            crossAxisAlignment: message.isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // 🔹 خود پیام
                              Align(
                                alignment: message.isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: message.isUser
                                        ? const Color.fromRGBO(255, 255, 253, 1)
                                        : const Color.fromARGB(
                                            255,
                                            246,
                                            247,
                                            251,
                                          ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(
                                      color: message.isUser
                                          ? Colors.black87
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              // 🔹 آیکون‌ها (فقط پیام ربات)
                              if (!message.isUser) ...[
                                Row(
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
                                      tooltip: 'Refresh',
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('refreshing... 🔄'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
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
                    color: const Color.fromARGB(150, 237, 242, 248),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromARGB(255, 238, 238, 238),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          58,
                          53,
                          53,
                        ).withAlpha(25),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 4),
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
                              color: Color.fromARGB(137, 79, 79, 80),
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
                            if (showWelcomeText.value) {
                              showWelcomeText.value =
                                  false; // متن خوشامدگویی محو می‌شود
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ), // padding کمی برای زیبایی
                    child: const Text(
                      "We store cookies to improve your experience. \n Policy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(150, 175, 177, 181),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
