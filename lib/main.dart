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
          fontFamily: 'opensans',

          fontFamilyFallback: const ['Estedad'],

          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Chat Bot',

        home: const SplashScreen(),
      ),
    );
  }
}
