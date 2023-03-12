import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor:
            isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
        primaryColor: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: isDarkTheme
                  ? const Color(0xFF1a1f3c)
                  : const Color(0xFFE8FDFD),
              brightness: isDarkTheme ? Brightness.dark : Brightness.light,
            ),
        cardColor:
            isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
        shadowColor:
            isDarkTheme ? const Color(0xFF0a0d2c) : Colors.grey.shade500,
        splashColor:
            isDarkTheme ? const Color(0xFF0a0d2c) : Colors.grey.shade300,
        canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
        dividerColor: isDarkTheme ? Colors.white : Colors.black,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light()));
  }
}
