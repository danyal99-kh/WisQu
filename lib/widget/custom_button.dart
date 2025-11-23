// lib/widgets/button.dart
import 'package:flutter/material.dart';
import 'package:wisqu/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;

  static const double _buttonHeight = 37.0;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? context.colors.primary,
        minimumSize: const Size(double.infinity, _buttonHeight),
        maximumSize: const Size(double.infinity, _buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 2,
        padding: EdgeInsets.zero,
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: context.colors.buttonText,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
    );
  }
}
