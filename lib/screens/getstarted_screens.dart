// lib/login_dialog.dart
// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'continue_with_email_screen.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // تار شدن پس‌زمینه
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  // Glassmorphism
                  color: Colors.white.withOpacity(0.15), // شفافیت شیشه‌ای
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3), // حاشیه سفید مات
                    width: 1.2,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ],
                  ),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(225, 234, 242, 1),
                          image: const DecorationImage(
                            image: AssetImage("assets/gradient.png"),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(146, 149, 153, 1),
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.12,
                              child: Image.asset(
                                "assets/logo.png",
                                color: const Color.fromARGB(255, 88, 88, 88),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Sign Up to Continue With \n WisQu",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 88, 88, 88),
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
                              label: const Text("Continue with Google"),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color.fromRGBO(
                                  224,
                                  229,
                                  237,
                                  1,
                                ),
                                foregroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 37),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ContinueWithEmailScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 37),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Continue with Email"),
                            ),
                          ],
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
