import 'package:flutter/material.dart';

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
  String? _confirmPasswordError;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    setState(() {
      if (confirmPassword.isNotEmpty &&
          confirmPassword != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              padding: EdgeInsets.all(screenWidth * 0.04),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Password", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(240, 244, 250, 1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              prefixIcon: Image.asset(
                                'assets/icons/lock.png',
                                width: 22,
                                height: 22,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    12.0,
                                  ), // برای تنظیم فاصله
                                  child: Image.asset(
                                    _isPasswordVisible
                                        ? 'assets/icons/eye.png'
                                        : 'assets/icons/eyeclosed.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),

                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 244, 250, 1),
                              hintText: "Enter your password",
                              errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 230, 81, 70),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (value) => _updateProgress(value),
                          ),
                        ),
                      ],
                    ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
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
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(240, 244, 250, 1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller:
                                _confirmPasswordController, // اصلاح کنترلر
                            obscureText: !_isConfirmPasswordVisible,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              prefixIcon: Image.asset(
                                'assets/icons/lock.png',
                                width: 22,
                                height: 22,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    _isConfirmPasswordVisible
                                        ? 'assets/icons/eye.png'
                                        : 'assets/icons/eyeclosed.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),

                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 244, 250, 1),
                              hintText: "Confirm password",
                              errorText: _confirmPasswordError,
                              errorStyle: const TextStyle(
                                color: Color.fromARGB(255, 230, 81, 70),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (value) =>
                                _validateConfirmPassword(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_confirmPasswordError == null &&
                            _strengthLevel >= 2.0) {
                          // اقدام برای ایجاد حساب
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(93, 63, 211, 1),
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.04,
                          ),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
