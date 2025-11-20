import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/getstarted_screens.dart';
import 'package:wisqu/screens/sidebar.dart';
import 'package:wisqu/state/auth_provider.dart';
import 'package:wisqu/theme/app_theme.dart';
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
      backgroundColor: context.colors.background,

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
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.surface
                                          : context.colors.inputField,
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
                                              color: context.colors.separator,
                                              width: 1.0,
                                            )
                                          : null,
                                    ),
                                    child: Text(
                                      message.text,
                                      style: TextStyle(
                                        color: context.colors.textIcon,
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
                                  color: context.colors.textIcon,
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
                              color: context.colors.popupBackground,
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
                                            colorFilter: ColorFilter.mode(
                                              context.colors.primary,
                                              BlendMode.srcIn,
                                            ),
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
                                            backgroundColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          child: Text(
                                            "Get Started",
                                            style: TextStyle(
                                              color: context.colors.buttonText,
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
                                            colorFilter: ColorFilter.mode(
                                              context.colors.textIcon,
                                              BlendMode.srcIn,
                                            ),
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
                                          Text(
                                            "WisQu",
                                            style: TextStyle(
                                              color: context.colors.textIcon,
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
                                                  side: BorderSide(
                                                    color: context
                                                        .colors
                                                        .separator, // #E5E7EB
                                                    width: 2,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ), // گرد کامل برای ارتفاع 36
                                                  ),
                                                  backgroundColor:
                                                      context.colors.background,
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
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            context
                                                                .colors
                                                                .textIcon,
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),

                                                    const SizedBox(
                                                      width: 8,
                                                    ), // gap: 8px
                                                    Text(
                                                      "Share",
                                                      style: TextStyle(
                                                        color: context
                                                            .colors
                                                            .textIcon,
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
                                                colorFilter: ColorFilter.mode(
                                                  context.colors.textIcon,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  showSettingsPopup(context),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  showLoginDialog(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).primaryColor,
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
                                              child: Text(
                                                "Get Started",
                                                style: TextStyle(
                                                  color:
                                                      context.colors.buttonText,
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
                    color: context.colors.inputField, // #EDF2FAB2
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.textIcon.withOpacity(0.08),
                        offset: const Offset(0, 4),
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
                                      color: context.colors.textIcon,
                                      height: 1.4,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "What do you want to know?",
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: context.colors.hintText,
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
                                decoration: BoxDecoration(
                                  color: context.colors.background,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colors.separator,
                                    width: 1,
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: SvgPicture.asset(
                                    "assets/icons/Send.svg",
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      context.colors.primary,
                                      BlendMode.srcIn,
                                    ),
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
                        color: context.colors.hintText,
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
            colorFilter: ColorFilter.mode(
              context.colors.textIcon, // همه آیکون‌ها این رنگ
              BlendMode.srcIn,
            ),
            child: icon,
          ),
          onPressed: onPressed,
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
          colorFilter: ColorFilter.mode(
            context.colors.textIcon,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
