import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.tealAccent,
      secondary: Colors.teal,
    ),
    scaffoldBackgroundColor: const Color(0xFF151515),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF151515),
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.tealAccent,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
