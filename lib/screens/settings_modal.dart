import 'package:flutter/material.dart';

void showSettingsPopup(BuildContext context) {
  OverlayEntry? entry;
  final overlay = Overlay.of(context);

  final AnimationController controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 150),
  );

  final Animation<double> scale = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutBack,
  );

  entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // ✅ لایه شفاف برای بستن پاپ‌آپ با کلیک بیرون
        GestureDetector(
          onTap: () {
            controller.reverse().then((_) {
              entry?.remove();
            });
          },
          behavior: HitTestBehavior.translucent,
          child: Container(color: Colors.transparent),
        ),

        // ✅ خود پاپ‌آپ
        Positioned(
          top: 80,
          right: 43,
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                width: 170,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 10,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ ردیف آیکون‌ها
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconItem('assets/icons/moon.png'),
                        _iconItem('assets/icons/sun.png'),
                        _iconItem('assets/icons/compoter.png'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ✅ Language
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 8),
                        Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
  controller.forward();
}

Widget _iconItem(String assetName, {Color? color}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: Image.asset(
      assetName,
      width: 22,
      height: 22,
      color: color, // ← رنگ PNG رو عوض می‌کنه (فقط اگر PNG تک‌رنگ باشه)
    ),
  );
}
