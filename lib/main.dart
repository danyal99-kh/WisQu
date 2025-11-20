// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/auth_provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'package:wisqu/state/theme_provider.dart';
import 'package:wisqu/screens/splash_screen.dart';
import 'package:wisqu/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wisqu',

            // کنترل تم
            themeMode: themeProvider.themeMode,

            // ⭐ استفاده از AppTheme 
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
