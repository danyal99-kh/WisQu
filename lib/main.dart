import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,

          fontFamily: 'OpenSans',

          // اگر کاراکتر فارسی بود → Estedad
          fontFamilyFallback: const ['Estedad'],

          // همه استایل‌های متنی بولد باشن
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.w600),
            displayMedium: TextStyle(fontWeight: FontWeight.w600),
            displaySmall: TextStyle(fontWeight: FontWeight.w600),
            headlineLarge: TextStyle(fontWeight: FontWeight.w600),
            headlineMedium: TextStyle(fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontWeight: FontWeight.w600),
            titleSmall: TextStyle(fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontWeight: FontWeight.w600),
            bodySmall: TextStyle(fontWeight: FontWeight.w600),
            labelLarge: TextStyle(fontWeight: FontWeight.w600),
            labelMedium: TextStyle(fontWeight: FontWeight.w600),
            labelSmall: TextStyle(fontWeight: FontWeight.w600),
          ).apply(fontFamily: 'OpenSans'),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Chat Bot',

        home: const SplashScreen(),
      ),
    );
  }
}
