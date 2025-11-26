// widgets/chat_input.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  final ChatProvider chatProvider;
  final bool keyboardOpen;
  final VoidCallback onSendMessage;
  final ValueNotifier<bool>? isTyping;
  final VoidCallback? onNewChat;
  const ChatInput({
    super.key,
    required this.chatProvider,
    required this.keyboardOpen,
    required this.onSendMessage,
    this.isTyping,
    this.onNewChat,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  ValueNotifier<bool> _isTyping = ValueNotifier(false);
  final ValueNotifier<double> _textFieldHeight = ValueNotifier(60.0);
  final int _maxLines = 4;
  final double _singleLineHeight = 60.0;
  final double _lineHeight = 20.0; // ارتفاع تقریبی هر خط

  @override
  void initState() {
    super.initState();
    _isTyping = widget.isTyping ?? ValueNotifier(false);

    // اضافه کردن listener برای تغییرات متن
    widget.chatProvider.textController.addListener(_updateTextFieldHeight);
  }

  void _updateTextFieldHeight() {
    final text = widget.chatProvider.textController.text;
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(fontSize: 16, height: 1.4),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: _maxLines,
    );
    textPainter.layout(maxWidth: 300); // عرض تقریبی فیلد متن

    final lineCount = textPainter.computeLineMetrics().length;
    final newHeight = _singleLineHeight + ((lineCount - 1) * _lineHeight);

    // محدود کردن ارتفاع به حداکثر 4 خط
    final maxHeight = _singleLineHeight + ((_maxLines - 1) * _lineHeight);
    _textFieldHeight.value = newHeight.clamp(_singleLineHeight, maxHeight);
  }

  @override
  void dispose() {
    widget.chatProvider.textController.removeListener(_updateTextFieldHeight);
    _isTyping.dispose();
    _textFieldHeight.dispose();
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
    return ValueListenableBuilder<double>(
      valueListenable: _textFieldHeight,
      builder: (context, height, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 380,
          height: height,
          constraints: BoxConstraints(
            maxHeight: _singleLineHeight + ((_maxLines - 1) * _lineHeight),
          ),
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: const Offset(2, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.inputField.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.separator.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextInput(),
                    const SizedBox(width: 8),
                    _buildSendButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            maxLines: _maxLines,
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
    return ValueListenableBuilder<bool>(
      valueListenable: _isTyping,
      builder: (context, typing, child) {
        return GestureDetector(
          onTap: () {
            if (typing) {
              widget.onSendMessage();
              _isTyping.value = false;
            }
          },
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: context.colors.background.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.separator2, width: 1),
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
                onPressed: null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }
}
