// lib/state/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system; // 👍 بهترین حالت اولیه

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

  /// ⭐ تغییر تم دارک/لایت
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  /// ⭐ فعال کردن حالت سیستم (با 1 خط)
  void setSystem() => setThemeMode(ThemeMode.system);

  /// ⭐ انتخاب حالت دلخواه
  void setLight() => setThemeMode(ThemeMode.light);
  void setDark() => setThemeMode(ThemeMode.dark);

  /// ⭐ متد اصلی تغییر تم
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveToPrefs();
    notifyListeners();
  }

  /// ⭐ لود از SharedPreferences
  Future<void> _loadFromPrefs() async {
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
      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  /// ⭐ ذخیره در SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final value = _themeMode == ThemeMode.dark
        ? 'dark'
        : _themeMode == ThemeMode.light
        ? 'light'
        : 'system';

    await prefs.setString(_key, value);
  }
}
