import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/screens/ResetPasword.dart';
import 'package:wisqu/screens/home_screen.dart';
import 'package:wisqu/state/auth_provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/theme/app_theme.dart';
import 'package:wisqu/widget/custom_button.dart';
import 'package:wisqu/widget/custom_textfield.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PasswordLoginPage();
  }
}

class PasswordLoginPage extends StatefulWidget {
  const PasswordLoginPage({super.key});

  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

bool _showError = false;
String _errorMessage = '';

class _PasswordLoginPageState extends State<PasswordLoginPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final ValueNotifier<String?> _passwordError = ValueNotifier<String?>(null);

  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    _passwordError.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    final password = _passwordController.text.trim();

    // ریست ارور
    _passwordError.value = null;

    // اعتبارسنجی
    if (password.isEmpty) {
      _passwordError.value = 'Please enter your password';
      return;
    }

    if (password.length < 4) {
      _passwordError.value = 'Password must be at least 4 characters';
      return;
    }

    // شروع لودینگ
    setState(() => _isLoading = true);

    // شبیه‌سازی لاگین
    await Future.delayed(const Duration(seconds: 2));

    // لاگین موفق
    Provider.of<AuthProvider>(context, listen: false).login();
    Provider.of<ChatProvider>(context, listen: false).startNewChat();

    if (!mounted) return;

    // پیام خوش‌آمدگویی
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              "Welcome back!",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5D3FD3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false, // همه صفحات قبلی حذف بشن
    );
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
      body: Form(
        key: _formKey,
        child: AnimatedContainer(
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
                  color: context.colors.hintText,
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
                    Text(
                      " Password",
                      style: TextStyle(
                        color: context.colors.hintText,
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Enter your password",
                      icon: SvgPicture.asset(
                        "assets/icons/lock.svg",
                        width: 24,
                        height: 24,
                      ),
                      isPassword: true,
                      errorNotifier: _passwordError, // این مهمه!
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _showError ? 24 : 0,
                      padding: _showError
                          ? const EdgeInsets.only(left: 16, top: 4)
                          : EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      child: _showError
                          ? Text(
                              _errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: context.colors.hintText,
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
                              child: Text(
                                "Reset pasword",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.colors.accent,
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
                child: CustomButton(
                  onPressed: _isLoading ? () {} : _performLogin,
                  isLoading: _isLoading,
                  text: 'login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
