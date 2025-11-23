// lib/widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/theme/app_theme.dart';
import '../state/chat_provider.dart';
import 'dart:ui';

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
  final FocusNode _focusNode = FocusNode();

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
      backgroundColor: context.colors.background,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            color: context.colors.sidebarHeaderBackground,

            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              children: [
                // آواتار کاربر
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color.fromARGB(255, 223, 222, 222),
                  child: SvgPicture.asset("assets/icons/logo.svg", height: 28),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      // سایه دقیقاً مثل درخواست شما: 0 4px 8px rgba(0,0,0,0.08)
                      boxShadow: _isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0x14000000), // #00000014
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: _isFocused ? 5.0 : 0.0,
                          sigmaY: _isFocused ? 5.0 : 0.0,
                        ),
                        child: Container(
                          height: 42,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: _isFocused
                                ? context.colors.searchBoxFocusedBackground
                                      .withOpacity(0.5)
                                : context.colors.searchBoxBackground
                                      .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: _isFocused
                                ? Border.all(
                                    color: context.colors.separator2,
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
                                color: context.colors.hintText,
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  "assets/icons/serch.svg",
                                  width: 16,
                                  height: 16,
                                  color: context.colors.textIcon,
                                ),
                              ),
                              suffixIcon: _isFocused
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 18,
                                        color: context.colors.textIcon,
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
                    color: context.colors.textIcon,
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
                    color: context.colors.hintText,
                  ),
                ),
              ],
            ),
          ),

          // لیست تاریخچه
          Expanded(
            child: ClipRect(
              child: filteredHistory.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? "No chat history yet"
                            : "No results found",
                        style: TextStyle(color: context.colors.hintText),
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
                            color: context.colors.background,

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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
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
                                color: context.colors.hintText,
                              ),
                            ),
                            trailing: IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/3.svg",
                                width: 18,
                                height: 18,
                              ),
                              onPressed: () {
                                _showBottomMenu(
                                  context,
                                  chat,
                                  chatProvider,
                                  isPinned,
                                );
                              },
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
          ),
        ],
      ),
    );
  }

  void _showBottomMenu(
    BuildContext context,
    ChatSession chat,
    ChatProvider provider,
    bool isPinned,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: context.colors.separator2, width: 0.8),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 16),
                    width: 58,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.colors.separator2,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                _buildMenuItem(
                  iconSvgPath: "assets/icons/pen1.svg",
                  title: "Rename",
                  onTap: () {
                    Navigator.pop(ctx);
                    _showRenameDialog(context, chat, provider);
                  },
                ),
                const SizedBox(height: 5),
                _buildMenuItem(
                  iconSvgPath: isPinned
                      ? "assets/icons/pin2.svg"
                      : "assets/icons/pin1.svg",
                  title: isPinned ? "Unpin" : "Pin",
                  onTap: () {
                    Navigator.pop(ctx);
                    provider.togglePinChat(chat.id);
                  },
                ),
                const SizedBox(height: 5),
                _buildMenuItem(
                  iconSvgPath: "assets/icons/delete.svg",
                  title: "Delete",
                  onTap: () async {
                    Navigator.pop(ctx);
                    final confirmed = await _showDeleteDialog(context);
                    if (confirmed) provider.deleteChat(chat.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    Widget? iconWidget,
    String? iconSvgPath,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: iconSvgPath != null
          ? SvgPicture.asset(iconSvgPath, width: 22, height: 22)
          : icon != null
          ? Icon(icon, size: 22)
          : const SizedBox(width: 22, height: 22),
      title: Text(
        title,
        style: TextStyle(color: context.colors.textIcon, fontSize: 15),
      ),
      onTap: onTap,
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
