import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 247, 251),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 119, 72, 200),
        title: const Text("Get Started"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to WisQu!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 72, 72, 72),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "This is where you can get started with exploring the app, sending messages, and using all the features we offer.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(150, 72, 72, 72),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // برگرد به صفحه اصلی
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 119, 72, 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
