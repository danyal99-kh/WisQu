import 'package:flutter/material.dart';
import 'package:wisqu/screens/home_screen.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  void _updateProgress(String password) {
    print('Password entered: $password'); // دیباگ برای چک کردن ورودی
    setState(() {
      if (password.length < 8) {
        _strengthLevel = 0.0; // ضعیف
      } else {
        if (password.contains(RegExp(r'[A-Z]'))) {
          if (password.contains(RegExp(r'[0-9]'))) {
            if (password.contains(RegExp(r'[!@#\$%^&*]'))) {
              _strengthLevel = 3.0; // خیلی قوی
            } else {
              _strengthLevel = 2.0; // خوب
            }
          } else {
            _strengthLevel = 1.0; // متوسط
          }
        } else if (password.contains(RegExp(r'[0-9]')) &&
            password.contains(RegExp(r'[!@#\$%^&*]'))) {
          _strengthLevel =
              2.0; // خوب (حرف بزرگ الزامی نیست اگه عدد و علامت باشه)
        } else {
          _strengthLevel = 0.0; // ضعیف
        }
      }
    });
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
              SizedBox(height: screenHeight * 0.1),
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
              SizedBox(height: screenHeight * 0.04),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.12,
                    height: screenHeight * 0.02,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 0.0
                          ? Colors.red
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Container(
                    width: screenWidth * 0.12,
                    height: screenHeight * 0.02,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 1.0
                          ? Colors.yellow
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Container(
                    width: screenWidth * 0.12,
                    height: screenHeight * 0.02,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 2.0
                          ? Colors.green
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Container(
                    width: screenWidth * 0.12,
                    height: screenHeight * 0.02,
                    decoration: BoxDecoration(
                      color: _strengthLevel >= 3.0
                          ? Colors.green[700]!
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
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
              SizedBox(height: screenHeight * 0.04),
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
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
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
              SizedBox(height: screenHeight * 0.1), // فاصله از پایین برای تعادل
            ],
          ),
        ),
      ),
    );
  }
}
