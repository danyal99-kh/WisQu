// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';
import 'dart:ui'; // برای ImageFilter.blur

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isFocused = false;
  bool _hasText = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
      width: screenWidth * 1,
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
                  backgroundColor: const Color.fromARGB(255, 131, 131, 131),
                ),

                const SizedBox(width: 8),

                // 🔥 درست‌شده: Search Box با سایه صحیح
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: _isFocused
                          ? [
                              BoxShadow(
                                color: const Color.fromARGB(19, 0, 0, 0),
                                offset: const Offset(0, 3),
                                blurRadius: 3,
                              ),
                            ]
                          : [],
                    ),

                    // ClipRRect نباید Wrap اصلی باشه
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: _isFocused ? 10 : 0,
                          sigmaY: _isFocused ? 10 : 0,
                        ),

                        child: Container(
                          height: 42,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: _isFocused
                                ? const Color(0xB2EDF2FA)
                                : const Color.fromARGB(53, 219, 219, 219),
                            borderRadius: BorderRadius.circular(18),
                            border: _isFocused
                                ? Border.all(
                                    color: const Color(0xFFD1D5DB),
                                    width: 1,
                                  )
                                : null,
                          ),

                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search History",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  "assets/icons/serch.svg",
                                  width: 16,
                                  height: 16,
                                ),
                              ),

                              // ضربدر فقط هنگام فوکوس
                              suffixIcon: _isFocused
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 18,
                                        color: Color.fromARGB(255, 26, 26, 26),
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = "";
                                        });
                                        _focusNode.unfocus();
                                      },
                                    )
                                  : null,

                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/sidbar.svg",
                    width: 18,
                    height: 18,
                  ),
                ),
              ],
            ),
          ),
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
                    physics: const ClampingScrollPhysics(),
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      final chat = filteredHistory[index];
                      final isPinned = chat.isPinned;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(221, 255, 255, 255),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          enableFeedback: false,
                          selectedTileColor: const Color.fromARGB(
                            255,
                            160,
                            160,
                            160,
                          ),
                          selected: chatProvider.currentChatId == chat.id,
                          tileColor: const Color.fromARGB(221, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(
                            16,
                            1,
                            1,
                            1,
                          ),
                          title: Row(
                            children: [
                              if (isPinned)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: SvgPicture.asset(
                                    "assets/icons/pin.svg",
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  chat.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
                            icon: SvgPicture.asset(
                              "assets/icons/3.svg",
                              width: 18,
                              height: 18,
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
                                    isPinned
                                        ? SvgPicture.asset(
                                            "assets/icons/pin2.svg",
                                            width: 22,
                                            height: 22,
                                          )
                                        : SvgPicture.asset(
                                            "assets/icons/pin1.svg",
                                            width: 22,
                                            height: 22,
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
        elevation: 5,
        backgroundColor: Colors.white,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(93, 63, 211, 1),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.renameChat(chat.id, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
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
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: const Text("Delete Chat"),
            content: const Text("Are you sure you want to delete this chat?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 103, 94),
                ),
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
