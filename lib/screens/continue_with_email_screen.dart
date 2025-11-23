// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wisqu/screens/home_screen.dart';
import 'package:wisqu/screens/password_screen.dart';
import 'package:wisqu/widget/custom_button.dart';
import 'package:wisqu/theme/app_theme.dart';
import 'package:wisqu/widget/custom_textfield.dart';

class ContinueWithEmailScreen extends StatelessWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailLoginPage();
  }
}

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<EmailLoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late final ValueNotifier<String?> _emailErrorNotifier;

  bool _showError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailErrorNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailErrorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final double horizontalPadding = size.width * 0.06;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
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
                child: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: size.width * 0.1,
                  height: size.height * 0.15,
                  color: context.colors.textIcon,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

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
                child: Text(
                  'Sign up or sign in using your email \naddress',
                  style: TextStyle(color: context.colors.textIcon),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),

              // 🔹 فیلد ایمیل
              // فیلد ایمیل - حالا کاملاً با تم و CustomTextField هماهنگه
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        color: context.colors.hintText,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // استفاده از CustomTextField به جای کد دستی
                    ValueListenableBuilder<String?>(
                      valueListenable:
                          _emailErrorNotifier, // باید یه ValueNotifier بسازی
                      builder: (context, error, _) {
                        return CustomTextField(
                          controller: _emailController,
                          hintText: "example@email.com",
                          icon: SvgPicture.asset(
                            "assets/icons/mail.svg",
                            width: 24,
                            height: 24,
                            color: context.colors.primary,
                          ),
                          errorNotifier: _emailErrorNotifier,

                          onTap: () {
                            // اگر نیاز داری وقتی تپ شد ارور پاک بشه
                            if (_emailErrorNotifier.value != null) {
                              _emailErrorNotifier.value = null;
                            }
                          },
                        );
                      },
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

                    // پاک کردن خطا
                    _emailErrorNotifier.value = null;

                    if (email.isEmpty) {
                      _emailErrorNotifier.value = "Please enter your email";
                      return;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(email)) {
                      _emailErrorNotifier.value = "Please enter a valid email";
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PasswordScreen()),
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
                    backgroundColor: context.colors.background,
                    minimumSize: const Size(double.infinity, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(
                      // حاشیه!
                      color: context.colors.separator,
                      width: 2,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Go back',
                    style: TextStyle(color: context.colors.textIcon),
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
