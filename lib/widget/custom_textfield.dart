// lib/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String iconPath;
  final TextEditingController controller;
  final bool isPassword; // فقط برای نمایش آیکون چشم
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap; // فقط برای فیلد
  final bool readOnly;
  final String? errorMessage;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.iconPath,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.errorMessage,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // مقدار اولیه
  late bool _showError;
  String? _errorMessage;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _showError = false;
    _errorMessage = null;

    // اضافه کن:
    _focusNode.addListener(() {
      setState(() {}); // وقتی فوکوس تغییر کرد، rebuild کن
    });

    widget.controller.addListener(() {
      if (_showError) {
        setState(() {
          _showError = false;
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // مهم!
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),

        SizedBox(
          height: 50,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: const Color.fromARGB(178, 237, 242, 250),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: widget.errorMessage != null
                    ? Colors.red
                    : (_focusNode.hasFocus || hasText || isKeyboardOpen)
                    ? const Color.fromRGBO(93, 63, 211, 1)
                    : Colors.grey.withOpacity(0.3),
                width: widget.errorMessage != null ? 1.5 : 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: _obscureText,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    widget.iconPath,
                    width: 25,
                    height: 25,
                    color: const Color.fromRGBO(93, 63, 211, 1),
                  ),
                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: _toggleObscureText,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              _obscureText
                                  ? 'assets/icons/eyeclosed.png'
                                  : 'assets/icons/eye.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none, // این را نگه دارید
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(170, 170, 170, 0.984),
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                  // این دو تا رو هم اضافه کن (برای بوردر قرمز)
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,

                  // این‌ها را اضافه کنید:
                  focusedBorder: InputBorder.none, // مهم!
                  enabledBorder: InputBorder.none, // مهم!
                ),
                style: const TextStyle(fontSize: 16),
                validator: widget.validator,
              ),
            ),
          ),
        ),

        // پیام خطا
        // پیام خطا
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.errorMessage != null ? 20 : 0,
          padding: widget.errorMessage != null
              ? const EdgeInsets.only(left: 16, top: 4)
              : EdgeInsets.zero,
          child: widget.errorMessage != null
              ? Text(
                  widget.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  key: ValueKey(widget.errorMessage),
                )
              : null,
        ),
      ],
    );
  }
}
