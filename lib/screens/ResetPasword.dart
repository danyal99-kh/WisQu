import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:wisqu/screens/confrimPasswordScreen.dart';

class ResetPasword extends StatefulWidget {
  const ResetPasword({super.key});

  @override
  State<ResetPasword> createState() => _ResetPaswordState();
}

class _ResetPaswordState extends State<ResetPasword> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int? _focusedIndex;
  late TapGestureRecognizer _resendRecognizer;

  @override
  void initState() {
    super.initState();
    _resendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _resendCode();
      };
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _resendRecognizer.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _resendCode() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code resent successfully!')));
  }

  Widget _buildCodeInput(int index, double screenWidth) {
    final bool isFocused = _focusedIndex == index;
    final double boxSize = screenWidth * 0.14; // اندازه پایه

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Transform.scale(
        scale: isFocused ? 1.1 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(240, 245, 250, 1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isFocused
                  ? const Color.fromRGBO(93, 63, 211, 1) // رنگ وقتی فوکوس هست
                  : const Color.fromARGB(
                      192,
                      201,
                      201,
                      201,
                    ), // رنگ خاکستری ملایم
              width: isFocused ? 2.0 : 1.0, // ضخامت متفاوت در فوکوس و غیر فوکوس
            ),

            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  210,
                  104,
                  103,
                  103,
                ).withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: boxSize * 0.6,
              height: boxSize * 0.6,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                maxLength: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: boxSize * 0.35, // 35% اندازه باکس
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  if (value.length == 1 && index < 5) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final _ = mediaQuery.orientation == Orientation.landscape;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final double horizontalPadding = screenWidth * 0.9;
    return Scaffold(
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Padding(
          padding: EdgeInsets.only(
            top: keyboardHeight > 0 ? screenHeight * 0.1 : screenHeight * 0.01,
            bottom: 1,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Your Verification Code',
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // اندازه فونت نسبی
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02), // 2% ارتفاع صفحه
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.037,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(text: 'We have sent a'),
                    TextSpan(
                      text: ' 6-digit code ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: 'to your email address.'),
                  ],
                ),
              ),
              Text(
                'Please enter the code to continue.',
                style: TextStyle(
                  fontSize: screenWidth * 0.037,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => _buildCodeInput(index, screenWidth),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: screenWidth * 0.037,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "Didn't receive the email? Check your spam folder or ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Resend code',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 236, 90, 155),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _resendRecognizer,
                    ),
                    const TextSpan(text: ' in 01:00'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                width: horizontalPadding,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePasswordScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                    backgroundColor: const Color.fromRGBO(93, 63, 211, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
