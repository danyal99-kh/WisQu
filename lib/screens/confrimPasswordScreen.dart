import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/auth_provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/widget/custom_button.dart';
import 'package:wisqu/widget/custom_textfield.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  double _strengthLevel = -1.0;
  final ValueNotifier<String?> _confirmPasswordError = ValueNotifier<String?>(
    null,
  );
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      _updateProgress(_passwordController.text);
      // وقتی پسورد تغییر کرد، اگر confirm هم پر بود دوباره چک کن
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });

    _confirmPasswordController.addListener(() {
      _validateConfirmPassword(_confirmPasswordController.text);
    });
  }

  void _updateProgress(String password) {
    setState(() {
      if (password.isEmpty) {
        _strengthLevel = -1.0;
        return;
      }

      int score = 0;

      // فقط اگر طول کافی باشد، امتیاز عدم تکرار بده
      if (password.length >= 8) {
        score += 20 + ((password.length - 8) * 2).clamp(0, 20);

        // فقط وقتی طول کافی است، چک کن که الگوی تکراری نداشته باشد
        if (!_hasRepetitivePattern(password)) {
          score += 20;
        }
      }

      // این‌ها همیشه چک می‌شوند (حتی در رمزهای کوتاه)
      if (password.contains(RegExp(r'[A-Z]'))) score += 10;
      if (password.contains(RegExp(r'[a-z]'))) score += 10;
      if (password.contains(RegExp(r'[0-9]'))) score += 10;
      if (password.contains(RegExp(r'[!@#\$%^&*]'))) score += 10;

      int charTypes = 0;
      if (password.contains(RegExp(r'[A-Z]'))) charTypes++;
      if (password.contains(RegExp(r'[a-z]'))) charTypes++;
      if (password.contains(RegExp(r'[0-9]'))) charTypes++;
      if (password.contains(RegExp(r'[!@#\$%^&*]'))) charTypes++;

      // تنوع کاراکتر فقط وقتی مفید است که طول کافی باشد
      if (password.length >= 8 && charTypes >= 3) {
        score += 20;
      }

      // حالا سطح قدرت را تعیین کن
      if (score <= 25) {
        _strengthLevel = 0.0;
      } else if (score <= 50) {
        _strengthLevel = 1.0;
      } else if (score <= 75) {
        _strengthLevel = 2.0;
      } else {
        _strengthLevel = 3.0;
      }
    });
  }

  bool _hasRepetitivePattern(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i] == password[i + 2]) {
        return true;
      }
    }
    if (password.contains(
      RegExp(
        r'(012|123|234|345|456|567|678|789|987|876|765|654|543|432|321|210)',
      ),
    )) {
      return true;
    }
    return false;
  }

  void _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _confirmPasswordError.value = null;
    } else if (confirmPassword != _passwordController.text) {
      _confirmPasswordError.value = 'Passwords do not match';
    } else {
      _confirmPasswordError.value = null;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
    _confirmPasswordError.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final double horizontalPadding = screenWidth * 0.03; // 6% عرض
    final double verticalPadding = screenHeight * 0.02; // 2% ارتفاع
    final textFieldWidth = screenWidth * 0.92;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // شروع از بالا
                children: [
                  SizedBox(height: screenHeight * 0.05), // کاهش فاصله از بالا
                  Text(
                    'Create Your Password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // کاهش اندازه فونت
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    'Please create a strong password that is easy for you to remember but difficult for others to guess.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                    ), // کاهش اندازه فونت
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Password", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        icon: SvgPicture.asset(
                          "assets/icons/lock.svg",
                          width: 24,
                          height: 24,
                        ),
                        isPassword: true,
                        errorNotifier: ValueNotifier<String?>(
                          null,
                        ), // یا یه ثابت خالی
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 19,
                        color: const Color.fromRGBO(93, 63, 211, 1),
                      ),
                      SizedBox(width: screenWidth * 0.005),
                      Container(
                        width: textFieldWidth * 0.225,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: _strengthLevel >= 0.0
                              ? Colors.red
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.005),
                      Container(
                        width: textFieldWidth * 0.225,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: _strengthLevel >= 1.0
                              ? Colors.yellow
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.005),
                      Container(
                        width: textFieldWidth * 0.225,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: _strengthLevel >= 2.0
                              ? Colors.green
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.005),
                      Container(
                        width: textFieldWidth * 0.225,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: _strengthLevel >= 3.0
                              ? Colors.green[700]!
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    _strengthLevel == -1.0
                        ? '' // یا 'Enter a password' اگر خواستی
                        : _strengthLevel == 0.0
                        ? 'Weak'
                        : _strengthLevel == 1.0
                        ? 'Medium'
                        : _strengthLevel == 2.0
                        ? 'Good'
                        : 'Very Strong',
                    style: TextStyle(
                      color: _strengthLevel == 0.0
                          ? Colors.red
                          : _strengthLevel == 1.0
                          ? Colors.yellow
                          : _strengthLevel == 2.0
                          ? Colors.green
                          : _strengthLevel == 3.0
                          ? Colors.green[700]
                          : Colors.grey, // وقتی -1 است، رنگ خاکستری
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm your password',
                        icon: SvgPicture.asset(
                          "assets/icons/lock.svg",
                          width: 24,
                          height: 24,
                        ),
                        isPassword: true,
                        errorNotifier: _confirmPasswordError, // این مهمه!
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  CustomButton(
                    onPressed: () async {
                      // اعتبارسنجی مجدد
                      _validateConfirmPassword(_confirmPasswordController.text);

                      if (_confirmPasswordError.value != null) return;

                      if (_strengthLevel < 2.0 ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please choose a stronger password (Good or higher)",
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // همه چیز درسته → شبیه‌سازی ساخت اکانت
                      await Future.delayed(const Duration(seconds: 2));

                      // لاگین کاربر
                      Provider.of<AuthProvider>(context, listen: false).login();
                      Provider.of<ChatProvider>(
                        context,
                        listen: false,
                      ).startNewChat();

                      if (!mounted) return;

                      // پیام موفقیت فارسی و زیبا
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Password created successfully! 🎉",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF5D3FD3),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          duration: const Duration(seconds: 3),
                          elevation: 10,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      );

                      // برگشت به صفحه اصلی
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    text: 'Create Account',
                  ),
                  SizedBox(
                    height: bottomInset > 0
                        ? screenHeight * 0.02
                        : screenHeight * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
