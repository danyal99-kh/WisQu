import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/sidebar.dart';
import 'package:wisqu/theme/app_theme.dart';
import 'package:wisqu/widget/app_header_home.dart';
import 'package:wisqu/widget/chat_input_home.dart';
import '../../state/chat_provider.dart';
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
    isTyping.dispose();
    super.dispose();
  }

  void _onSendMessage() {
    final chatProvider = context.read<ChatProvider>();

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
                              20,
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
                                          : context.colors.background,
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
                                                // آیکون‌های پیام کاربر
                                                if (message.isUser) ...[
                                                  // آیکون کپی برای تمام پیام‌های کاربر
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
                                                  // آیکون مداد فقط برای آخرین پیام کاربر
                                                  if (isLastUserMessage)
                                                    _buildIconButton(
                                                      icon: SvgPicture.asset(
                                                        "assets/icons/pen.svg",
                                                        width: 18,
                                                        height: 18,
                                                      ),
                                                      tooltip: 'Edit',
                                                      onPressed: () {},
                                                    ),
                                                ],

                                                // آیکون‌های پیام ربات
                                                if (!message.isUser) ...[
                                                  // ترتیب از راست به چپ: دیسلایک، لایک، کپی، رفرش
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/Refresh.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Regenerate',
                                                    onPressed: () {},
                                                  ),
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
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/thumbs-up.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Like',
                                                    onPressed: () {},
                                                  ),
                                                  _buildIconButton(
                                                    icon: SvgPicture.asset(
                                                      "assets/icons/thumbs-down.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    tooltip: 'Dislike',
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
                                color: context.colors.textIcon,
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
                        child: AppHeader(
                          scaffoldKey: _scaffoldKey,
                          chatProvider: chatProvider,
                        ),
                      ),
                    ],
                  ),
                ),
                ChatInput(
                  chatProvider: chatProvider,
                  keyboardOpen: keyboardOpen,
                  onSendMessage: _onSendMessage,
                  isTyping: isTyping,
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
