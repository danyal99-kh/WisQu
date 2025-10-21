import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 247, 251),
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 246, 247, 251),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: IconButton(
              color: const Color.fromARGB(255, 119, 72, 200),
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ElevatedButton.icon(
              onPressed: () {},
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
          Expanded(
            child: chatProvider.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logo.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'WisQu\nHello, What can I help you with?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 72, 72, 72),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: chatProvider.scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return Column(
                        crossAxisAlignment: message.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // 🔹 خود پیام
                          Align(
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
                                    ? const Color.fromRGBO(255, 255, 253, 1)
                                    : const Color.fromARGB(255, 246, 247, 251),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isUser
                                      ? Colors.black87
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),

                          // 🔹 آیکون‌ها (فقط برای پیام‌های ربات)
                          if (!message.isUser) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 18,
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    150,
                                    150,
                                    150,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You liked this response 👍',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 1),
                                IconButton(
                                  icon: const Icon(
                                    Icons.thumb_down_alt_outlined,
                                    size: 18,
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    150,
                                    150,
                                    150,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You disliked this response 👎',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 1),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  color: const Color.fromARGB(
                                    255,
                                    150,
                                    150,
                                    150,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: message.text),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Message copied 📋'),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 1),
                                IconButton(
                                  icon: const Icon(Icons.sync, size: 18),
                                  color: const Color.fromARGB(
                                    255,
                                    150,
                                    150,
                                    150,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: message.text),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('refreshing... 🔄'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(height: 1),
          // 🔹 TextField و متن پایین
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // فیلد تایپ
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(150, 237, 242, 248),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromARGB(255, 238, 238, 238),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 58, 53, 53).withAlpha(
                          (0.5 * 50).round(),
                        ), // رنگ خاکستری روشن با شفافیت
                        blurRadius: 10, // میزان تار شدن سایه
                        spreadRadius: 5, // پهنای سایه
                        offset: const Offset(0, 4), // شیب سایه: افقی و عمودی
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatProvider.textController,
                          minLines: 1,
                          maxLines: 4,

                          decoration: const InputDecoration(
                            hintText: "What do you want to know?",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(137, 79, 79, 80),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded),
                        color: const Color.fromARGB(255, 119, 72, 200),
                        onPressed: chatProvider.sendMessage,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We store cookies to improve your experience. By using our app, you agree to our Cookie and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(150, 175, 177, 181),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
