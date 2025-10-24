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
      body: Padding(
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
                // مسیر صفحه قوانین یا URL
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
          ],
        ),
      ),
    );
  }
}
