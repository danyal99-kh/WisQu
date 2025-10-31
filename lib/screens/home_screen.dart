import 'dart:ui';

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
  final ValueNotifier<bool> showWelcomeText = ValueNotifier(true);
  final ValueNotifier<bool> isTyping = ValueNotifier(false);
  final ValueNotifier<int?> _selectedMessageIndex = ValueNotifier(null);
  late final AnimationController _messageAnimController;

  @override
  void initState() {
    super.initState();
    _messageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _messageAnimController.dispose();
    _selectedMessageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    bool isTyping = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF6F7FA),

      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🔹 لیست پیام‌ها (زیر خوشامدگویی)
                      ListView.builder(
                        controller: chatProvider.scrollController,
                        padding: EdgeInsets.only(
                          top: chatProvider.messages.length > 1
                              ? kToolbarHeight +
                                    MediaQuery.of(context).padding.top +
                                    18
                              : 12,
                          left: 16,
                          right: 16,
                          bottom: 90,
                        ),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          final isLastUserMessage =
                              message.isUser &&
                              index ==
                                  chatProvider.messages.lastIndexWhere(
                                    (m) => m.isUser,
                                  );
                          final isLastBotMessage =
                              !message.isUser &&
                              index ==
                                  chatProvider.messages.lastIndexWhere(
                                    (m) => !m.isUser,
                                  );

                          final bool isSelected =
                              _selectedMessageIndex.value == index;

                          final bool showActionsByDefault =
                              !message.isUser &&
                              index == chatProvider.messages.length - 1;
                          Widget messageWidget = GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMessageIndex.value =
                                    _selectedMessageIndex.value == index
                                    ? null
                                    : index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: message.isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  // --- پیام ---
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 14,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: message.isUser
                                          ? const Color.fromRGBO(
                                              255,
                                              255,
                                              253,
                                              1,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              246,
                                              247,
                                              251,
                                            ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: const Radius.circular(16),
                                        bottomRight: message.isUser
                                            ? const Radius.circular(9)
                                            : const Radius.circular(16),
                                      ),
                                      border: message.isUser
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                255,
                                                129,
                                                129,
                                                129,
                                              ).withOpacity(0.3),
                                              width: 1.0,
                                            )
                                          : null,
                                    ),
                                    child: Text(
                                      message.text,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position:
                                              Tween<Offset>(
                                                begin: const Offset(0, 0.5),
                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOutCubic,
                                                ),
                                              ),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child:
                                        _selectedMessageIndex.value == index ||
                                            showActionsByDefault
                                        ? Padding(
                                            key: ValueKey('actions_$index'),
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              top: 1,
                                              bottom: 1,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                _buildIconButton(
                                                  icon: Image.asset(
                                                    "assets/icons/copy.png",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  tooltip: 'Copy',
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                        text: message.text,
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Message copied',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                if (message.isUser &&
                                                    isLastUserMessage)
                                                  _buildIconButton(
                                                    icon: Image.asset(
                                                      "assets/icons/pen.png",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    tooltip: 'Edit',
                                                    onPressed: () {},
                                                  ),
                                                if (!message.isUser) ...[
                                                  _buildIconButton(
                                                    icon: Image.asset(
                                                      "assets/icons/thumbs-up.png",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    tooltip: 'Like',
                                                    onPressed: () {},
                                                  ),
                                                  _buildIconButton(
                                                    icon: Image.asset(
                                                      "assets/icons/thumbs-down.png",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    tooltip: 'Dislike',
                                                    onPressed: () {},
                                                  ),
                                                  _buildIconButton(
                                                    icon: Image.asset(
                                                      "assets/icons/refresh-cw.png",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    tooltip: 'Regenerate',
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          );

                          // انیمیشن پیام جدید
                          if (!message.isUser &&
                              index == chatProvider.messages.length - 1) {
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

                          return messageWidget;
                        },
                      ),

                      // متن خوشامدگویی (روی لیست)
                      ValueListenableBuilder<bool>(
                        valueListenable: showWelcomeText,
                        builder: (context, isVisible, child) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: isVisible ? 1.0 : 0.0,
                            curve: Curves.easeInOutCubic,
                            child: IgnorePointer(
                              ignoring: !isVisible,
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
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height:
                                  kToolbarHeight +
                                  MediaQuery.of(context).padding.top +
                                  25,
                              color: Colors.white.withOpacity(0.15),
                              child: Padding(
                                // فقط padding افقی
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // لوگو و نام
                                    ValueListenableBuilder<bool>(
                                      valueListenable: showWelcomeText,
                                      builder: (context, isVisible, _) {
                                        if (isVisible) return const SizedBox();
                                        return Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/logo.png',
                                                height: 34,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              "WisQu",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  72,
                                                  72,
                                                  72,
                                                ),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                    // دکمه‌ها
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Image.asset(
                                            "assets/icons/settings.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const SettingsScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 80,
                                            maxWidth: 130,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                showLoginDialog(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF5D3FD3,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              minimumSize: const Size(0, 35),
                                            ),
                                            child: const FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Get Started",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // تکست فیلد
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // کادر تکست فیلد با بلور داخلی
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  // ClipRRect برای برش گوشه‌ها قبل از بلور
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 3,
                      ), // بلور قوی‌تر
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            251,
                            255,
                            255,
                          ).withOpacity(0.7), // شفافیت کمتر برای Glassmorphism
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    isTyping = value.trim().isNotEmpty;
                                  });
                                },
                                controller: chatProvider.textController,
                                minLines: 1,
                                maxLines: 4,
                                style: const TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  filled: false,
                                  border: InputBorder.none,
                                  hintText: "What do you want to know?",
                                  hintStyle: TextStyle(
                                    color: isTyping
                                        ? Colors.black87
                                        : Colors.grey[600],
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapDown: (_) => setState(() {}),
                              onTapUp: (_) => setState(() {}),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    // این خط جدیده!
                                    color: const Color.fromARGB(
                                      255,
                                      206,
                                      206,
                                      206,
                                    ), // رنگ حاشیه
                                    width: 1.0, // ضخامت حاشیه
                                  ),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                width: 36,
                                height: 36,

                                child: IconButton(
                                  icon: Image.asset(
                                    width: 20,
                                    height: 20,
                                    "assets/icons/Send.png",
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    119,
                                    72,
                                    200,
                                  ),
                                  onPressed: () {
                                    _selectedMessageIndex.value =
                                        null; // پاک کردن انتخاب قبلی
                                    chatProvider.sendMessage(
                                      onNewBotMessage: () {
                                        _messageAnimController.reset();
                                        _messageAnimController.forward();
                                      },
                                    );
                                    if (showWelcomeText.value) {
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () {
                                          showWelcomeText.value = false;
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!keyboardOpen)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: Text(
                      "Trained on religious ruling questions. By messaging, you agree to our Terms and Privacy Policy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.030,
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

  Widget _buildIconButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() {}),
        onTapUp: (_) => setState(() {}),
        child: IconButton(
          icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(255, 121, 121, 121), // همه آیکون‌ها این رنگ
              BlendMode.srcIn,
            ),
            child: icon,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
