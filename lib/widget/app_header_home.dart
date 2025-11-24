// widgets/app_header.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/settings_modal.dart';
import 'package:wisqu/screens/getstarted_screens.dart';
import 'package:wisqu/state/auth_provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ChatProvider chatProvider;

  const AppHeader({
    super.key,
    required this.scaffoldKey,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
          color: context.colors.popupBackground,
          padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
          child: Consumer2<AuthProvider, ChatProvider>(
            builder: (context, authProvider, chatProvider, child) {
              return _buildHeaderContent(context, authProvider, chatProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(
    BuildContext context,
    AuthProvider authProvider,
    ChatProvider chatProvider,
  ) {
    final bool isLoggedIn = authProvider.isLoggedIn;
    final bool hasMessages = chatProvider.messages.isNotEmpty;

    // حالت 1: تازه وارد شده → فقط Settings + Get Started
    if (!isLoggedIn && !hasMessages) {
      return _buildLoggedOutHeader(context);
    }

    return _buildLoggedInHeader(context, isLoggedIn);
  }

  Widget _buildLoggedOutHeader(BuildContext context) {
    final GlobalKey _settingsButtonKey = GlobalKey();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Settings
        IconButton(
          key: _settingsButtonKey,
          icon: SvgPicture.asset(
            "assets/icons/settings.svg",
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              context.colors.primary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => showSettingsPopup(context, _settingsButtonKey),
        ),
        const SizedBox(width: 8),
        // Get Started
        ElevatedButton(
          onPressed: () => showLoginDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  Widget _buildLoggedInHeader(BuildContext context, bool isLoggedIn) {
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
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),

        if (isLoggedIn) const SizedBox(width: 5),

        _buildLogoSection(context),

        const Spacer(),

        // راست: دکمه‌های عملیاتی
        _buildActionButtons(context, isLoggedIn),
      ],
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            height: 36,
            fit: BoxFit.contain,
            color: context.colors.textIcon,
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
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLoggedIn) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoggedIn) ...[
          _buildNewChatButton(context),
          _buildShareButton(context),
        ]
        // اگر لاگین نکرده ولی پیام فرستاده → فقط Settings + Get Started
        else ...[
          _buildSettingsButton(context),
          const SizedBox(width: 8),
          _buildGetStartedButton(context),
        ],
      ],
    );
  }

  Widget _buildNewChatButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        chatProvider.startNewChat();
        // اگر showWelcomeText در Provider جداگانه باشد
        // context.read<UIProvider>().showWelcomeText.value = true;
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: SvgPicture.asset(
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

  Widget _buildShareButton(BuildContext context) {
    return SizedBox(
      width: 79,
      height: 36,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Share feature coming soon!")),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          side: BorderSide(color: context.colors.separator, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: context.colors.background,
          elevation: 0,
          minimumSize: const Size(36, 36),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/icons/share.svg",
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                context.colors.textIcon,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Share",
              style: TextStyle(
                color: context.colors.textIcon,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    final GlobalKey _settingsButtonKey = GlobalKey();

    return IconButton(
      key: _settingsButtonKey,
      icon: SvgPicture.asset(
        "assets/icons/settings.svg",
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(context.colors.textIcon, BlendMode.srcIn),
      ),
      onPressed: () => showSettingsPopup(context, _settingsButtonKey),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showLoginDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        "Get Started",
        style: TextStyle(
          color: context.colors.buttonText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
