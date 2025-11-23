import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/theme_provider.dart';

void showSettingsPopup(BuildContext context, GlobalKey buttonKey) {
  final RenderBox button =
      buttonKey.currentContext!.findRenderObject() as RenderBox;
  final Offset buttonPosition = button.localToGlobal(Offset.zero);

  OverlayEntry? entry;

  final AnimationController controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 300),
  )..forward();

  final Animation<double> scale = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutBack,
  );

  entry = OverlayEntry(
    builder: (context) => Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Stack(
          children: [
            // کلیک بیرون = بستن
            GestureDetector(
              onTap: () {
                controller.reverse().then((_) {
                  entry?.remove();
                  controller.dispose();
                });
              },
              child: Container(color: Colors.transparent),
            ),

            // پاپ‌آپ
            Positioned(
              top: buttonPosition.dy + button.size.height + 8,
              left: buttonPosition.dx - 72,
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      // ✅ اضافه کردن سایه
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0x00000000,
                          ).withOpacity(0.08), // #00000014
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: BackdropFilter(
                        // ✅ backdrop-filter: blur(32px)
                        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                        child: Container(
                          width: 172,
                          height: 52,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withOpacity(0.35)
                                : Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.black.withOpacity(0.08),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _themeIcon(
                                context: context,
                                asset: 'assets/icons/moon.svg',
                                mode: ThemeMode.dark,
                                isActive:
                                    themeProvider.themeMode == ThemeMode.dark,
                                controller: controller,
                                entry: entry!,
                              ),
                              const SizedBox(width: 6),
                              _themeIcon(
                                context: context,
                                asset: 'assets/icons/sun.svg',
                                mode: ThemeMode.light,
                                isActive:
                                    themeProvider.themeMode == ThemeMode.light,
                                controller: controller,
                                entry: entry!,
                              ),
                              const SizedBox(width: 6),
                              _themeIcon(
                                context: context,
                                asset: 'assets/icons/compoter.svg',
                                mode: ThemeMode.system,
                                isActive:
                                    themeProvider.themeMode == ThemeMode.system,
                                controller: controller,
                                entry: entry!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  Overlay.of(context).insert(entry);
}

Widget _themeIcon({
  required BuildContext context,
  required String asset,
  required ThemeMode mode,
  required bool isActive,
  required AnimationController controller,
  required OverlayEntry entry,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  return GestureDetector(
    onTap: () {
      themeProvider.setThemeMode(mode);
      controller.reverse().then((_) {
        entry.remove();
        controller.dispose();
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isActive
            ? _getActiveColor(context, themeProvider)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        asset,
        width: 20,
        height: 20,
        color: _getIconColor(context, themeProvider, isActive),
      ),
    ),
  );
}

Color _getActiveColor(BuildContext context, ThemeProvider themeProvider) {
  return themeProvider.isDarkMode
      ? Colors.white.withOpacity(0.2)
      : Colors.blue.withOpacity(0.15);
}

Color _getIconColor(
  BuildContext context,
  ThemeProvider themeProvider,
  bool isActive,
) {
  if (isActive) {
    return themeProvider.isDarkMode ? Colors.white : Colors.blue;
  }
  return themeProvider.isDarkMode
      ? Colors.white.withOpacity(0.7)
      : Colors.black87;
}
