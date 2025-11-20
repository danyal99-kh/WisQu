// lib/login_dialog.dart
// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wisqu/theme/app_theme.dart';
import 'package:wisqu/widget/custom_button.dart';
import 'continue_with_email_screen.dart';

void showLoginDialog(BuildContext context) {
  final colors = context.colors;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // بلور قوی‌تر
              child: Container(
                color: Colors.black.withOpacity(
                  0.1,
                ), // تیره کردن ملایم پس‌زمینه
              ),
            ),
            // تار شدن پس‌زمینه
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  // Glassmorphism
                  color: colors.popupBackground.withOpacity(
                    0.1,
                  ), // شفافیت شیشه‌ای
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: colors.separator.withOpacity(0.3), // حاشیه سفید مات
                    width: 1.2,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Column(mainAxisSize: MainAxisSize.min, children: []),
                ),
              ),
            ),
            // کادر فرم
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.85,
                        maxHeight: constraints.maxHeight * 0.8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 25,
                            ),
                            decoration: BoxDecoration(
                              color: colors.background.withOpacity(
                                0.8,
                              ), // ← شفاف!
                              image: const DecorationImage(
                                image: AssetImage("assets/gradient.png"),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: colors.separator,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Image.asset(
                                      "assets/icons/minimize.png",
                                      height: 20,
                                      color: colors.textIcon,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.12,
                                  child: Image.asset(
                                    "assets/logo.png",
                                    color: colors.textIcon,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Sign Up to Continue With \n WisQu",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors.textIcon,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "assets/google-logo.png",
                                    height: 24,
                                  ),
                                  label: Text(
                                    "Continue with Google",
                                    style: TextStyle(color: colors.textIcon),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: colors.inputField,
                                    foregroundColor: colors.textIcon,
                                    minimumSize: const Size(
                                      double.infinity,
                                      37,
                                    ),
                                    side: BorderSide(color: colors.separator),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ContinueWithEmailScreen(),
                                      ),
                                    );
                                  },
                                  text: 'Continue With Email',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
