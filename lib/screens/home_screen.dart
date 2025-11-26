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

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _showWelcomeText = true;
  bool _isTyping = false;
  int? _selectedMessageIndex;

  late final AnimationController _messageAnimController;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

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
    super.dispose();
  }

  void _onSendMessage() {
    final chatProvider = context.read<ChatProvider>();

    setState(() {
      _selectedMessageIndex = null;
    });

    chatProvider.sendMessage(
      onNewBotMessage: () {
        if (mounted) {
          _messageAnimController.reset();
          _messageAnimController.forward();
        }
      },
    );

    if (_showWelcomeText) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _showWelcomeText = false;
          });
        }
      });
    }
  }

  void _startNewChat() {
    final chatProvider = context.read<ChatProvider>();
    chatProvider.startNewChat();

    setState(() {
      _showWelcomeText = true;
      _selectedMessageIndex = null;
    });

    FocusScope.of(context).unfocus();
    _messageAnimController.reset();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final chatProvider = Provider.of<ChatProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final headerHeight = kToolbarHeight + MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldState,
      drawer: const AppSidebar(),
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          // 🔹 محتوای اصلی - کل صفحه رو پر میکنه
          Positioned.fill(
            child: Column(
              children: [
                // محتوای چت
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // لیست پیام‌ها
                      ListView.builder(
                        controller: chatProvider.scrollController,
                        padding: EdgeInsets.only(
                          top: headerHeight + 1, // فاصله برای هدر
                          left: 8,
                          right: 8,
                          bottom: keyboardOpen ? 90 : 120,
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
                                _selectedMessageIndex =
                                    _selectedMessageIndex == index
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
                                  // پیام
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

                                  // آیکون‌های اکشن
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
                                        _selectedMessageIndex == index ||
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
                                                if (message.isUser) ...[
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
                                                if (!message.isUser) ...[
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

                      // متن خوشامدگویی
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        opacity: _showWelcomeText ? 1.0 : 0.0,
                        curve: Curves.easeInOutCubic,
                        child: IgnorePointer(
                          ignoring: !_showWelcomeText,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: headerHeight,
                              bottom: 100,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/logo.svg',
                                  width: screenWidth * 0.3,
                                  height: screenHeight * 0.13,
                                  color: context.colors.textIcon,
                                  fit: BoxFit.contain,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 هدر شیشه‌ای (بالا روی محتوا)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              scaffoldKey: _scaffoldState,
              chatProvider: chatProvider,
              onNewChat: _startNewChat,
            ),
          ),

          // 🔹 چت اینپوت شیشه‌ای (پایین روی محتوا)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: ChatInput(
                chatProvider: chatProvider,
                keyboardOpen: keyboardOpen,
                onSendMessage: _onSendMessage,
                isTyping: ValueNotifier(_isTyping),
              ),
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
      child: IconButton(
        icon: ColorFiltered(
          colorFilter: ColorFilter.mode(
            context.colors.textIcon,
            BlendMode.srcIn,
          ),
          child: icon,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
