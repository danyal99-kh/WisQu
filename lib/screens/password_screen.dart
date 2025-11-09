import 'package:flutter/material.dart';
import 'package:wisqu/screens/ResetPasword.dart';
import 'package:wisqu/widget/custom_button.dart';
import 'package:wisqu/widget/custom_textfield.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

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

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isConfirmPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final double horizontalPadding = size.width * 0.06;
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.07;
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
          isKeyboardOpen ? -size.height * 0.09 : 0,
          0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),

            Text(
              'Welcome back, X!',
              style: TextStyle(
                color: Colors.black,
                fontSize: titleFontSize,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // 🔹 فیلد ایمیل
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter password",
                    iconPath: "assets/icons/lock.png",
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(text: "Forgot your password?  "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetPasword(),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CustomButton(onPressed: () {}, text: 'login'),
            ),
          ],
        ),
      ),
    );
  }
}
