// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:wisqu/screens/home_screen.dart';
import 'package:wisqu/screens/password_screen.dart';
import 'package:wisqu/widget/custom_button.dart';

class ContinueWithEmailScreen extends StatelessWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _showError = false; // فقط وقتی دکمه زده شد و خطا بود
String? _errorMessage;

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final double horizontalPadding = size.width * 0.06;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        transform: Matrix4.translationValues(
          0,
          isKeyboardOpen ? -size.height * 0.15 : 0,
          0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 لوگو
              AnimatedScale(
                scale: isKeyboardOpen ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  "assets/logo.png",
                  width: size.width * 0.35,
                  height: size.height * 0.18,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 متن توضیحی
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isKeyboardOpen
                      ? size.width * 0.04
                      : size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                child: const Text(
                  'Sign up or sign in using your email \naddress',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),

              // 🔹 فیلد ایمیل
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 50,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(178, 237, 242, 250),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _showError
                                ? Colors.red
                                : (MediaQuery.of(context).viewInsets.bottom >
                                          0 ||
                                      _emailController.text.isNotEmpty)
                                ? const Color.fromRGBO(93, 63, 211, 1)
                                : Colors.grey.withOpacity(0.3),
                            width: _showError ? 1.5 : 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color.fromRGBO(93, 63, 211, 1),
                                size: 25,
                              ),
                              border: InputBorder.none,
                              hintText: "example@email.com",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(170, 170, 170, 0.984),
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 4,
                              ),
                              errorStyle: const TextStyle(
                                height: 0,
                                fontSize: 0,
                              ),
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (_) {
                              setState(() {
                                _showError = false;
                                _errorMessage = null;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'required';
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value))
                                return 'invalid';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    // پیام خطا
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _showError ? 20 : 0,
                      padding: _showError
                          ? const EdgeInsets.only(left: 16, top: 4)
                          : EdgeInsets.zero,
                      child: _showError
                          ? Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              key: ValueKey(_errorMessage),
                            )
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // 🔹 دکمه Continue
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: CustomButton(
                  onPressed: () {
                    final email = _emailController.text.trim();

                    // ریست خطا
                    setState(() {
                      _showError = false;
                      _errorMessage = null;
                    });

                    // بررسی دستی (چون validator فقط برای فرم هست)
                    if (email.isEmpty) {
                      setState(() {
                        _showError = true;
                        _errorMessage = 'Please enter your email';
                      });
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordScreen(),
                      ),
                    );
                  },

                  text: 'Continue',
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 دکمه Go Back
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 247, 250, 1),
                    minimumSize: const Size(double.infinity, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      // حاشیه!
                      color: Color.fromRGBO(160, 160, 160, 0.385),
                      width: 1,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Go back',
                    style: TextStyle(color: Color.fromARGB(255, 33, 32, 32)),
                  ),
                ),
              ),

              SizedBox(height: isKeyboardOpen ? size.height * 0.1 : 0),
            ],
          ),
        ),
      ),
    );
  }
}
