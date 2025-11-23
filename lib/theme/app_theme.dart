import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wisqu/theme/app_fonts.dart';

class AppTheme {
  // تم لایت
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF5D3DF3),
    scaffoldBackgroundColor: const Color(0xFFF6F7FA),
    canvasColor: const Color(0xFFF6F7FA),
    fontFamily: AppFonts.openSans,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF5D3DF3),
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5D3DF3),
      secondary: Color(0xFFFF69B4),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFE74C3C),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFF404040),
      onError: Colors.white,
    ),

    extensions: <ThemeExtension<dynamic>>[CustomColors.light],
  );

  // تم دارک
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF9D81FF),
    scaffoldBackgroundColor: const Color(0xFF212121),
    canvasColor: const Color(0xFF212121),
    fontFamily: AppFonts.openSans,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF9D81FF),
    ),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9D81FF),
      secondary: Color(0xFFFF85C0),
      surface: Color(0xFF333333),
      error: Color(0xFFD9534F),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF3F4F6),
      onError: Colors.white,
    ),

    extensions: <ThemeExtension<dynamic>>[CustomColors.dark],
  );
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.inputField,
    required this.popupBackground,
    required this.searchBoxFocusedBackground,
    required this.textIcon,
    required this.buttonText,
    required this.separator,
    required this.separator2,
    required this.hintText,
    required this.success,
    required this.error,
    required this.textFieldFill, // رنگ جدید اضافه شد
    required this.cornerRadius,
    required this.sidebarHeaderBackground,
    required this.searchBoxBackground,
  });

  final Color primary;
  final Color accent;
  final Color background;
  final Color inputField;
  final Color searchBoxFocusedBackground;
  final Color popupBackground;
  final Color textIcon;
  final Color buttonText;
  final Color separator;
  final Color separator2;
  final Color hintText;
  final Color success;
  final Color searchBoxBackground;
  final Color error;
  final Color sidebarHeaderBackground;
  // رنگ جدید: پس‌زمینه فیلد متنی
  final Color textFieldFill;

  final double cornerRadius;

  // تم لایت
  static const CustomColors light = CustomColors(
    primary: Color(0xFF5D3DF3),
    accent: Color(0xFFFF69B4),
    background: Color(0xFFF6F7FA),
    searchBoxFocusedBackground: Color(0xB2EDF2FA),
    inputField: Color(0xB3EDF2FA),
    popupBackground: Color(0x4DFFFFFF),
    textIcon: Color(0xFF404040),
    buttonText: Color(0xFFFFFFFF),
    separator: Color(0xFFE5E7EB),
    separator2: Color(0xFFD1D5DB),
    hintText: Color(0xFF828282),
    success: Color(0xFF2ECC71),
    searchBoxBackground: Color(0x4DFFFFFE),
    error: Color(0xFFE74C3C),
    textFieldFill: Color(0xB2EDF2FA),
    sidebarHeaderBackground: Color(0x4DFFFFFE),
    cornerRadius: 20.0,
  );

  // تم دارک
  static const CustomColors dark = CustomColors(
    primary: Color(0xFF9D81FF),
    searchBoxFocusedBackground: Color(0x66888B8F),
    searchBoxBackground: Color(0x4D333333),
    accent: Color(0xFFFF85C0),
    background: Color(0xFF212121),
    inputField: Color(0x66888B8F),
    popupBackground: Color(0x4D333333),
    textIcon: Color(0xFFF3F4F6),
    buttonText: Color(0xFF333333),
    separator: Color(0xFF48494A),
    separator2: Color(0xFF6E7073),
    hintText: Color(0xFFD1D5DB),
    success: Color(0xFF28B463),
    error: Color(0xFFD9534F),
    textFieldFill: Color(0x66888B8F),
    cornerRadius: 20.0,
    sidebarHeaderBackground: Color(0x4D333333),
  );

  @override
  CustomColors copyWith({
    Color? primary,
    Color? sidebarHeaderBackground,
    Color? accent,
    Color? background,
    Color? searchBoxBackground,
    Color? inputField,
    Color? searchBoxFocusedBackground,
    Color? popupBackground,
    Color? textIcon,
    Color? buttonText,
    Color? separator,
    Color? separator2,
    Color? hintText,
    Color? success,
    Color? error,
    Color? textFieldFill,
    double? cornerRadius,
  }) {
    return CustomColors(
      searchBoxBackground: searchBoxBackground ?? this.searchBoxBackground,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      searchBoxFocusedBackground:
          searchBoxFocusedBackground ?? this.searchBoxFocusedBackground,
      background: background ?? this.background,
      inputField: inputField ?? this.inputField,
      popupBackground: popupBackground ?? this.popupBackground,
      textIcon: textIcon ?? this.textIcon,
      buttonText: buttonText ?? this.buttonText,
      separator: separator ?? this.separator,
      separator2: separator2 ?? this.separator2,
      hintText: hintText ?? this.hintText,
      success: success ?? this.success,
      error: error ?? this.error,
      textFieldFill: textFieldFill ?? this.textFieldFill,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      sidebarHeaderBackground:
          sidebarHeaderBackground ?? this.sidebarHeaderBackground,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      searchBoxBackground: Color.lerp(
        searchBoxBackground,
        other.searchBoxBackground,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      inputField: Color.lerp(inputField, other.inputField, t)!,
      popupBackground: Color.lerp(popupBackground, other.popupBackground, t)!,
      textIcon: Color.lerp(textIcon, other.textIcon, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      separator2: Color.lerp(separator2, other.separator2, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      success: Color.lerp(success, other.success, t)!,
      searchBoxFocusedBackground: Color.lerp(
        searchBoxFocusedBackground,
        other.searchBoxFocusedBackground,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      textFieldFill: Color.lerp(textFieldFill, other.textFieldFill, t)!,
      cornerRadius: lerpDouble(cornerRadius, other.cornerRadius, t)!,
      sidebarHeaderBackground: Color.lerp(
        sidebarHeaderBackground,
        other.sidebarHeaderBackground,
        t,
      )!,
    );
  }
}

// دسترسی راحت در همه جای پروژه
extension ThemeGetter on BuildContext {
  CustomColors get colors => Theme.of(this).extension<CustomColors>()!;
}
