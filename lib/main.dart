import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/chat_provider.dart';
import 'homescreen.dart';

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
        debugShowCheckedModeBanner: false,
        title: 'Chat Bot',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 246, 247, 251),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
