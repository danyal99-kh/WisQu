import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: IconButton(
              color: const Color.fromARGB(255, 119, 72, 200),
              icon: const Icon(Icons.settings),
              onPressed: () {
                print("Settings clicked");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ElevatedButton.icon(
              onPressed: () {
                print(" clicked");
              },
              label: const Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 72, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // لیست پیام‌ها
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16), // گردتر
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // باکس تایپ پیام و دکمه ارسال
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25), // گردتر
                    ),
                    child: TextField(
                      controller: chatProvider.textController,
                      decoration: const InputDecoration(
                        hintText: 'پیام خود را تایپ کنید...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      chatProvider.sendMessage();
                    },
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
