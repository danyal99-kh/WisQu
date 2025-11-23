import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wisqu/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final bool readOnly;

  // مهم: به جای ساختن ValueNotifier داخل constructor، از بیرون پاس بده
  final ValueNotifier<String?> errorNotifier;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.onTap,
    this.readOnly = false,
    required this.errorNotifier, // اجباری و بدون مشکل
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();

    // وقتی متن تغییر کرد یا فوکوس شد → rebuild + پاک کردن ارور
    _focusNode.addListener(() => setState(() {}));

    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty &&
          widget.errorNotifier.value != null) {
        widget.errorNotifier.value = null; // ارور خودکار پاک بشه
      }
      setState(() {});
    });

    // وقتی errorNotifier تغییر کرد → rebuild
    widget.errorNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.errorNotifier.removeListener(() {}); // پاک کردن listener
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorNotifier.value != null;
    final hasText = widget.controller.text.isNotEmpty;
    final isFocused = _focusNode.hasFocus;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),

        SizedBox(
          height: 56,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: context.colors.inputField,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isFocused || hasText || isKeyboardOpen)
                    ? context.colors.primary
                    : Colors.grey.withOpacity(0.3),
                width: hasError ? 2.0 : 1.2,
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
                validator: widget.validator,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: widget.icon,
                  ),

                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: _toggleObscureText,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              _obscureText
                                  ? 'assets/icons/eye-closed.svg' // وقتی پسورد مخفیه
                                  : 'assets/icons/eye.svg',
                              color: context.colors.primary,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: context.colors.hintText,
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 8,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),

        // پیام خطا
        ValueListenableBuilder<String?>(
          valueListenable: widget.errorNotifier,
          builder: (context, error, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: error != null ? 28 : 0,
              padding: error != null
                  ? const EdgeInsets.only(left: 16, top: 6)
                  : EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              child: error != null
                  ? Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
