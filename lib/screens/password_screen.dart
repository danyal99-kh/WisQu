import 'package:flutter/material.dart';
import 'package:wisqu/screens/ResetPasword.dart';

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
  String? _confirmPasswordError;
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
                      controller: _confirmPasswordController,
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
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(240, 244, 250, 1),
                        hintText: "Enter password",
                        errorText: _confirmPasswordError,
                        errorStyle: const TextStyle(
                          color: Color.fromARGB(255, 230, 81, 70),
                          fontSize: 14,
                        ),
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
            // 🔹 دکمه Continue
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
