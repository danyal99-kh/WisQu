import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/getstarted_screens.dart';
import 'package:wisqu/screens/sidebar.dart';
import 'package:wisqu/state/auth_provider.dart';
import '../../state/chat_provider.dart';
import 'package:wisqu/screens/settings_modal.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSidebar(),

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
                          top:
                              kToolbarHeight +
                              MediaQuery.of(context).padding.top +
                              20, // همیشه از زیر هدر شروع شه
                          left: 8,
                          right: 8,
                          bottom: 100,
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
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "opensans",
                                        fontWeight: FontWeight.w400,
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
                                                  icon: SvgPicture.asset(
                                                    "assets/icons/copy.svg",
                                                    width: 18,
                                                    height: 18,
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
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/pen.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Edit',
                                                    onPressed: () {},
                                                  ),
                                                if (!message.isUser) ...[
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/copy.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Like',
                                                    onPressed: () {},
                                                  ),
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/thumbs-up.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Dislike',
                                                    onPressed: () {},
                                                  ),
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/thumbs-down.svg",
                                                      width: 18,
                                                      height: 18,
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
                              child: SvgPicture.asset(
                                'assets/icons/logo.svg',
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
                                  8,
                              color: Colors.white.withOpacity(0.15),
                              padding: const EdgeInsets.only(
                                top: 18,
                                left: 12,
                                right: 12,
                              ),
                              child: Consumer2<AuthProvider, ChatProvider>(
                                builder: (context, authProvider, chatProvider, child) {
                                  final bool isLoggedIn =
                                      authProvider.isLoggedIn;
                                  final bool hasMessages =
                                      chatProvider.messages.isNotEmpty;

                                  // حالت 1: تازه وارد شده → فقط Settings + Get Started
                                  if (!isLoggedIn && !hasMessages) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Settings
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            "assets/icons/settings.svg",
                                            width: 22,
                                            height: 22,
                                          ),
                                          onPressed: () =>
                                              showSettingsPopup(context),
                                        ),
                                        const SizedBox(width: 8),
                                        // Get Started
                                        ElevatedButton(
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          child: const Text(
                                            "Get Started",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return Row(
                                    children: [
                                      if (isLoggedIn)
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            "assets/icons/sidbar.svg",
                                            width: 20,
                                            height: 20,
                                          ),
                                          onPressed: () => _scaffoldKey
                                              .currentState
                                              ?.openDrawer(),
                                        ),

                                      if (isLoggedIn) const SizedBox(width: 5),

                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/icons/logo.svg',
                                              height: 36,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "WisQu",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                72,
                                                72,
                                                72,
                                              ),
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      // راست: دکمه‌های عملیاتی
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isLoggedIn) ...[
                                            _buildNewChatButton(chatProvider),
                                            SizedBox(
                                              width: 79,
                                              height: 36,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Share feature coming soon!",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8,
                                                      ),
                                                  side: const BorderSide(
                                                    color: Color(
                                                      0xFFE5E7EB,
                                                    ), // #E5E7EB
                                                    width: 2,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ), // گرد کامل برای ارتفاع 36
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                  minimumSize: const Size(
                                                    36,
                                                    36,
                                                  ), // min-width & min-height
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/share.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),

                                                    const SizedBox(
                                                      width: 8,
                                                    ), // gap: 8px
                                                    const Text(
                                                      "Share",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                          // اگر لاگین نکرده ولی پیام فرستاده → فقط Settings + Get Started
                                          else ...[
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                "assets/icons/settings.svg",
                                                width: 20,
                                                height: 20,
                                              ),
                                              onPressed: () =>
                                                  showSettingsPopup(context),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
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
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              child: const Text(
                                                "Get Started",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  );
                                },
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
                // === تکست فیلد اصلی ===
                Container(
                  width: 380, // دقیقاً از فیگما
                  height: 60, // حالت اولیه
                  constraints: const BoxConstraints(
                    maxHeight: 100, // حداکثر ارتفاع
                  ),
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8, // gap بین فیلد و متن زیر
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(
                      209,
                      237,
                      242,
                      250,
                    ), // #EDF2FAB2
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(12), // دقیقاً از فیگما
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // === TextField ===
                            Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: isTyping,
                                builder: (context, typing, child) {
                                  return TextField(
                                    controller: chatProvider.textController,
                                    minLines: 1,
                                    maxLines: 3, // تا 100px جا بشه
                                    onChanged: (value) {
                                      isTyping.value = value.trim().isNotEmpty;
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: typing
                                          ? Colors.black87
                                          : const Color(0xFF8D8D8D),
                                      height: 1.4,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "What do you want to know?",
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF8D8D8D),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 8), // gap بین فیلد و دکمه
                            // === دکمه ارسال ===
                            GestureDetector(
                              onTapDown: (_) => setState(() {}),
                              onTapUp: (_) => setState(() {}),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFCECECE),
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: Color(0xFFCECECE),
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: Color(0xFFCECECE),
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: Color(0xFFCECECE),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: SvgPicture.asset(
                                    "assets/icons/Send.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  onPressed: () {
                                    _selectedMessageIndex.value = null;
                                    chatProvider.sendMessage(
                                      onNewBotMessage: () {
                                        _messageAnimController.reset();
                                        _messageAnimController.forward();
                                      },
                                    );
                                    if (showWelcomeText.value) {
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () => showWelcomeText.value = false,
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

                // === متن زیر فیلد ===
                if (!keyboardOpen)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Trained on religious ruling questions. By messaging, you agree to our Terms and Privacy Policy.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
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

  Widget _buildNewChatButton(ChatProvider chatProvider) {
    return GestureDetector(
      onTap: () {
        chatProvider.startNewChat();
        showWelcomeText.value = true;
        _selectedMessageIndex.value = null;
        FocusScope.of(context).unfocus();
        _messageAnimController.reset();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: // داخل _buildNewChatButton
        SvgPicture.asset(
          "assets/icons/newchat.svg",
          width: 20,
          height: 20,
          // colorFilter: const ColorFilter.mode(
          //   Color(0xFF374151),
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
}
