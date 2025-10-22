import 'package:flutter/material.dart';
import 'dart:async';
import 'homescreen.dart'; // صفحه اصلی برنامه

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 ثانیه صبر کن و بعد به صفحه اصلی برو
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/first_logo.png', width: 150, height: 150),
      ),
    );
  }
}
