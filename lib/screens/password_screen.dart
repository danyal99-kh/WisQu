// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:wisqu/screens/ForgotPasswordScreen.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false, // جلوگیری از اسکرول خودکار
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('auth.wisq.ai'),
        actions: [IconButton(icon: const Icon(Icons.shield), onPressed: () {})],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        // وقتی کیبورد باز میشه، کل محتوا کمی بالا میاد
        transform: Matrix4.translationValues(
          0,
          isKeyboardOpen ? -size.height * 0.09 : 0, // مقدار بالا رفتن
          0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 لوگو با انیمیشن کوچک شدن
            const SizedBox(height: 15),

            // 🔹 متن توضیحی با کوچک شدن تطبیقی
            const Text(
              'Welcome back, X!',
              style: TextStyle(color: Colors.black, fontSize: 30),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // 🔹 فیلد ایمیل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pasword", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: Color.fromRGBO(93, 63, 211, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(240, 244, 250, 1),
                        hintText: "Enter pasword",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: "Forgot your password?  ",
                        ), // متن عادی
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Reset pasword",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(93, 63, 211, 1),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
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
            SizedBox(height: 25),
            // 🔹 دکمه Continue
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(93, 63, 211, 1),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
