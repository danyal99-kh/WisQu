import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 119, 72, 200),
      ),
      body: Stack(
        children: [
          // پس‌زمینه‌ی ساده (می‌تونی عکس بزاری اگه خواستی)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // محتوای اصلی
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text("Dark Mode"),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  trailing: Switch(
                    value: notifications,
                    onChanged: (value) {
                      setState(() {
                        notifications = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy Policy"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Privacy Policy tapped")),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About App"),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "WisQu",
                      applicationVersion: "1.0.0",
                      applicationLegalese: "© 2025 WisQu",
                    );
                  },
                ),
                const Spacer(),

                /// 🎨 دکمه با تم گلس شیشه‌ای
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Glass Button Pressed ✨"),
                              ),
                            );
                          },
                          child: const Text(
                            "Glass Button",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
