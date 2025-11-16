// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // فیلتر تاریخچه بر اساس جستجو
    final filteredHistory = chatProvider.chatHistory.where((chat) {
      return chat.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Drawer(
      width: screenWidth * 0.85,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 251, 251, 251),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              children: [
                // آواتار کاربر
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage('assets/user_avatar.png'),
                  backgroundColor: Colors.grey[300],
                ),

                // فاصله کم بین آواتار و سرچ
                const SizedBox(width: 8),

                // فیلد جستجو (بدون Expanded)
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search Hisory",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 251, 251, 251),

                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    "assets/icons/saidbar.png",
                    width: 24,
                    height: 24,
                    color: const Color.fromARGB(255, 72, 72, 72),
                  ),
                ),
              ],
            ),
          ),
          // عنوان + جستجو
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),

          // فیلد جستجو
          const SizedBox(height: 8),

          // لیست تاریخچه
          Expanded(
            child: filteredHistory.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? "No chat history yet"
                          : "No results found",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      final chat = filteredHistory[index];
                      final isPinned = chat.isPinned;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(221, 255, 255, 255),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            8,
                            8,
                          ),
                          leading: isPinned
                              ? Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                )
                              : null,
                          title: Text(
                            chat.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "6 hours ago",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            color: Colors.white,
                            icon: Icon(
                              Icons.more_vert_sharp,
                              size: 20,
                              color: const Color.fromRGBO(93, 63, 211, 1),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) async {
                              if (value == 'rename') {
                                _showRenameDialog(context, chat, chatProvider);
                              } else if (value == 'pin' || value == 'unpin') {
                                chatProvider.togglePinChat(chat.id);
                              } else if (value == 'delete') {
                                final confirmed = await _showDeleteDialog(
                                  context,
                                );
                                if (confirmed) {
                                  chatProvider.deleteChat(chat.id);
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'rename',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 8),
                                    const Text("Rename"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: isPinned ? 'unpin' : 'pin',
                                child: Row(
                                  children: [
                                    Icon(
                                      isPinned
                                          ? Icons.push_pin_outlined
                                          : Icons.push_pin,
                                      size: 18,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(isPinned ? "Unpin" : "Pin"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.red[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            chatProvider.loadChat(chat.id);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // دیالوگ تغییر نام
  void _showRenameDialog(
    BuildContext context,
    ChatSession chat,
    ChatProvider provider,
  ) {
    final controller = TextEditingController(text: chat.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rename Chat"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.renameChat(chat.id, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // دیالوگ تأیید حذف
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Delete Chat"),
            content: const Text("Are you sure you want to delete this chat?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
