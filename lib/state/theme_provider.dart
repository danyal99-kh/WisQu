// lib/state/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;

  /// ⭐ تشخیص دقیق دارک مود (حتی زمانی که ThemeMode.system باشد)
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// ⭐ تشخیص اینکه آیا در حال حاضر از تم سیستم استفاده می‌شود
  bool get isSystemTheme => _themeMode == ThemeMode.system;

  /// ⭐ تشخیص تم فعلی برای نمایش در UI
  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// ⭐ تغییر تم دارک/لایت/سیستم به صورت چرخشی
  void cycleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
    }
  }

  /// ⭐ تغییر تم دارک/لایت (فقط بین این دو)
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  /// ⭐ فعال کردن حالت سیستم
  void setSystem() => setThemeMode(ThemeMode.system);

  /// ⭐ انتخاب حالت دلخواه
  void setLight() => setThemeMode(ThemeMode.light);
  void setDark() => setThemeMode(ThemeMode.dark);

  /// ⭐ متد اصلی تغییر تم
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _saveToPrefs();
      notifyListeners();
    }
  }

  /// ⭐ لود از SharedPreferences
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);

      switch (saved) {
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'system':
          _themeMode = ThemeMode.system;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (e) {
      // در صورت خطا از تم سیستم استفاده کن
      _themeMode = ThemeMode.system;
    }
  }

  /// ⭐ ذخیره در SharedPreferences
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final value = _themeMode == ThemeMode.dark
          ? 'dark'
          : _themeMode == ThemeMode.light
          ? 'light'
          : 'system';

      await prefs.setString(_key, value);
    } catch (e) {
      // خطا در ذخیره‌سازی - می‌توانید لاگ کنید
      debugPrint('Error saving theme: $e');
    }
  }

  /// ⭐ ریست به حالت پیش‌فرض (سیستم)
  void resetToDefault() {
    setThemeMode(ThemeMode.system);
  }

  /// ⭐ آیا تم در حالت دارک است (برای conditional styling)
  bool get isDark => isDarkMode;

  /// ⭐ آیا تم در حالت لایت است
  bool get isLight => !isDarkMode;
}
