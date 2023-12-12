import 'package:flutter/material.dart';

class AppTheme {
  static const Color _pastelGreen = Color.fromARGB(255, 212, 250, 247);
  static const Color _navyBlue = Color(0xFF003E75);
  static const Color _deepAqua = Color(0xFF00838F);

  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: _deepAqua, surface: _pastelGreen, tertiary: _navyBlue),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          surface: _deepAqua,
          seedColor: _pastelGreen,
          secondary: _deepAqua,
          brightness: Brightness.dark),
      //scaffoldBackgroundColor: Colors.black,
      // textTheme: const TextTheme(
      //   bodyLarge: TextStyle(color: Colors.white),
      //   bodyMedium: TextStyle(color: Colors.white),
      //   displayLarge: TextStyle(color: Colors.white, fontSize: 24),
      //   displayMedium: TextStyle(color: Colors.white, fontSize: 18),
      // ),
    );
  }
}
