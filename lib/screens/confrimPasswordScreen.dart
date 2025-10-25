import 'package:flutter/material.dart';
import 'package:wisqu/screens/home_screen.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  double _strengthLevel = 0.0; // 0: ضعیف, 1: متوسط, 2: خوب, 3: خیلی قوی
  String? _confirmPasswordError;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // تابع محاسبه قدرت رمز با امتیازدهی پویا
  void _updateProgress(String password) {
    print('Password entered: $password'); // دیباگ برای چک کردن ورودی
    setState(() {
      int score = 0;

      // 1. امتیاز طول (حداکثر 20)
      if (password.length >= 8) {
        score += 20 + ((password.length - 8) * 2).clamp(0, 20);
      }

      // 2. تنوع کاراکترها (حداکثر 40)
      if (password.contains(RegExp(r'[A-Z]'))) score += 10; // حروف بزرگ
      if (password.contains(RegExp(r'[a-z]'))) score += 10; // حروف کوچک
      if (password.contains(RegExp(r'[0-9]'))) score += 10; // اعداد
      if (password.contains(RegExp(r'[!@#\$%^&*]'))) score += 10; // علامت‌ها

      // 3. عدم تکرار و الگوهای ساده (حداکثر 20)
      if (!_hasRepetitivePattern(password)) score += 20;

      // 4. پیچیدگی (حداکثر 20)
      int charTypes = 0;
      if (password.contains(RegExp(r'[A-Z]'))) charTypes++;
      if (password.contains(RegExp(r'[a-z]'))) charTypes++;
      if (password.contains(RegExp(r'[0-9]'))) charTypes++;
      if (password.contains(RegExp(r'[!@#\$%^&*]'))) charTypes++;
      if (charTypes >= 3) score += 20;

      // تبدیل امتیاز به سطح (0-100 به 0-3)
      if (score <= 25) {
        _strengthLevel = 0.0; // ضعیف
      } else if (score <= 50) {
        _strengthLevel = 1.0; // متوسط
      } else if (score <= 75) {
        _strengthLevel = 2.0; // خوب
      } else {
        _strengthLevel = 3.0; // خیلی قوی
      }
    });
  }

  // تابع چک کردن الگوهای تکراری
  bool _hasRepetitivePattern(String password) {
    // چک کردن تکرارهای متوالی (مثل "aaa" یا "111")
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i] == password[i + 2]) {
        return true;
      }
    }
    // چک کردن الگوهای عددی ساده (مثل 123 یا 321)
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

    // عرض TextField بدون پدینگ و حاشیه
    final textFieldWidth = screenWidth * 0.92; // 92% از عرض صفحه

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text('auth.wisq.ai'),
        actions: [IconButton(icon: const Icon(Icons.shield), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1), // فاصله از بالا

              Text(
                'Create Your Password',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Please create a strong password that is easy for you remember but difficult for others to guess.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ), // فاصله بین متن و TextField
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: !_isPasswordVisible,
                onChanged: (value) => _updateProgress(value),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 19,
                    color: const Color.fromRGBO(93, 63, 211, 1),
                  ), // آیکون سپر
                  SizedBox(width: screenWidth * 0.005), // فاصله کمتر
                  Container(
                    width: textFieldWidth * 0.225, // عرض کمتر برای هر بخش
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 0.0
                          ? Colors.red
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.005), // فاصله کمتر
                  Container(
                    width: textFieldWidth * 0.225,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 1.0
                          ? Colors.yellow
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
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
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
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
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                _strengthLevel == 0.0
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
                      : Colors.green[700],
                  fontSize: screenWidth * 0.04,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Password',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ), // فاصله بین متن و TextField
              TextField(
                controller: _confirmPasswordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                  errorText: _confirmPasswordError,
                ),
                obscureText: !_isConfirmPasswordVisible,
                onChanged: (value) => _validateConfirmPassword(value),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  if (_confirmPasswordError == null && _strengthLevel >= 2.0) {
                    // اقدام برای ایجاد حساب
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(93, 63, 211, 1),
                  minimumSize: Size(double.infinity, 40), // ارتفاع 40 پیکسل
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
              SizedBox(height: screenHeight * 0.1), // فاصله از پایین
            ],
          ),
        ),
      ),
    );
  }
}
