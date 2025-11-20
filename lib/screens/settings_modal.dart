import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisqu/state/theme_provider.dart'; // مسیر رو درست کن اگه فرق داره

void showSettingsPopup(BuildContext context) {
  OverlayEntry? entry;
  final overlay = Overlay.of(context);

  final AnimationController controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 200),
  )..forward();

  final Animation<double> scale = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutBack,
  );

  entry = OverlayEntry(
    builder: (context) => Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final backgroundColor = isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF5F5F5);
        final textColor = isDark ? Colors.white : Colors.black87;
        final shadowColor = isDark
            ? Colors.black.withOpacity(0.5)
            : Colors.black.withOpacity(0.09);

        return Stack(
          children: [
            // لایه شفاف برای بستن با کلیک بیرون
            GestureDetector(
              onTap: () {
                controller.reverse().then((_) {
                  entry?.remove();
                  controller.dispose();
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),

            // خود پاپ‌آپ
            Positioned(
              top: 80,
              right: 43,
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: scale,
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ردیف تم‌ها
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _themeIcon(
                              context: context,
                              asset: 'assets/icons/moon.png',
                              mode: ThemeMode.dark,
                              isActive:
                                  themeProvider.themeMode == ThemeMode.dark,
                              controller: controller, // پاس دادیم
                              entry: entry!, // پاس دادیم
                            ),
                            _themeIcon(
                              context: context,
                              asset: 'assets/icons/sun.png',
                              mode: ThemeMode.light,
                              isActive:
                                  themeProvider.themeMode == ThemeMode.light,
                              controller: controller,
                              entry: entry!,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
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

  overlay.insert(entry);
}

Widget _themeIcon({
  required BuildContext context,
  required String asset,
  required ThemeMode mode,
  required bool isActive,
  required AnimationController controller, // این رو اضافه کردیم
  required OverlayEntry entry, // اینم اضافه کردیم
}) {
  return GestureDetector(
    onTap: () {
      // عوض کردن تم
      Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);

      // بستن پاپ‌آپ با انیمیشن (از controller و entry اصلی استفاده می‌کنیم)
      controller.reverse().then((_) {
        entry.remove();
        controller.dispose();
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.transparent,
          width: 2.5,
        ),
      ),
      child: Image.asset(
        asset,
        width: 26,
        height: 26,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87,
      ),
    ),
  );
}
