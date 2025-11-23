import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wisqu/theme/app_theme.dart';
import 'dart:async';
import 'home_screen.dart'; // صفحه اصلی برنامه

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          width: screenWidth * 0.2,
          height: screenHeight * 0.2,
          color: context.colors.textIcon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
