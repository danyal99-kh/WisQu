// widgets/chat_input.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  final ChatProvider chatProvider;
  final bool keyboardOpen;
  final VoidCallback onSendMessage;
  final ValueNotifier<bool>? isTyping;

  const ChatInput({
    super.key,
    required this.chatProvider,
    required this.keyboardOpen,
    required this.onSendMessage,
    this.isTyping,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  ValueNotifier<bool> _isTyping = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _isTyping = widget.isTyping ?? ValueNotifier(false);
  }

  @override
  void dispose() {
    _isTyping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // === تکست فیلد اصلی ===
        _buildTextField(),
        // === متن زیر فیلد ===
        if (!widget.keyboardOpen) _buildFooterText(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField() {
    return Container(
      width: 380, // دقیقاً از فیگما
      height: 60, // حالت اولیه
      constraints: const BoxConstraints(
        maxHeight: 100, // حداکثر ارتفاع
      ),
      margin: const EdgeInsets.only(
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
                _buildTextInput(),
                const SizedBox(width: 8), // gap بین فیلد و دکمه
                // === دکمه ارسال ===
                _buildSendButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Expanded(
      child: ValueListenableBuilder<bool>(
        valueListenable: _isTyping,
        builder: (context, typing, child) {
          return TextField(
            controller: widget.chatProvider.textController,
            minLines: 1,
            maxLines: 3, // تا 100px جا بشه
            onChanged: (value) {
              _isTyping.value = value.trim().isNotEmpty;
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
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) => setState(() {}),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.colors.background,
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.separator, width: 1),
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
            if (_isTyping.value) {
              widget.onSendMessage();
              _isTyping.value = false;
            }
          },
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Trained on religious ruling questions. By messaging, you agree to our Terms and Privacy Policy.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w300,
          color:
              Colors.grey, // می‌توانید از context.colors.hintText استفاده کنید
          fontSize: 12,
        ),
      ),
    );
  }
}
