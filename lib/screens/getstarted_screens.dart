// lib/login_dialog.dart
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
        child: Stack(
          children: [
            // تار شدن پس‌زمینه
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                height: 0,
                color: const Color.fromARGB(255, 35, 25, 25).withOpacity(0.2),
              ),
            ),
            // کادر فرم
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 234, 242, 1),

                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, right: 1),
                        child: IconButton(
                          icon: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.close_fullscreen_rounded,
                                size: 20,
                                color: Color.fromARGB(221, 54, 53, 53),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    // لوگو
                    SizedBox(
                      height: 100,
                      child: Image.asset("assets/logo.png"),
                    ),
                    const SizedBox(height: 20),
                    // متن عنوان
                    const Text(
                      "Sign Up to Continue With \n WisQu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // دکمه ورود با گوگل
                    ElevatedButton.icon(
                      onPressed: () {
                        // عملکرد ورود با گوگل
                      },
                      icon: Image.asset("assets/google-logo.png", height: 24),
                      label: const Text("Continue with Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(229, 233, 245, 1),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 37),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // دکمه ورود با ایمیل
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContinueWithEmailScreen(),
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
          ],
        ),
      );
    },
  );
}
