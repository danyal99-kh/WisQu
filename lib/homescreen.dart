import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 247, 251),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: chatProvider.messages.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      150 +
                                      MediaQuery.of(context).viewInsets.bottom /
                                          2 +
                                      100,
                                ),
                                // فاصله از بالا
                                Image.asset(
                                  'assets/logo.jpg',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text('Image not found');
                                  },
                                ),
                                SizedBox(height: 15),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '  WisQu \n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            72,
                                            72,
                                            72,
                                          ),
                                          fontSize: 50,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Hello',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            72,
                                            72,
                                            72,
                                          ),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ', What can I help \n             you with? ',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            72,
                                            72,
                                            72,
                                          ),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
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
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: message.isUser
                                          ? const Color.fromARGB(
                                              255,
                                              119,
                                              72,
                                              200,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              237,
                                              242,
                                              248,
                                            ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      message.text,
                                      style: TextStyle(
                                        color: message.isUser
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 35),
                    // 🔹 فیلد تایپ و متن پایین
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔸 فیلد تایپ پیام
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
                                  color: const Color.fromARGB(
                                    255,
                                    183,
                                    183,
                                    183,
                                  ).withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: chatProvider.textController,
                                    decoration: const InputDecoration(
                                      hintText: "What do you want to know?",
                                      hintStyle: TextStyle(
                                        color: Color.fromARGB(137, 79, 79, 80),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Color.fromARGB(255, 119, 72, 200),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      chatProvider.sendMessage();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔸 متن پایین
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "We store cookies to improve your experience. By using our app, you agree to our Cookie and Privacy Policy.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(150, 175, 177, 181),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
