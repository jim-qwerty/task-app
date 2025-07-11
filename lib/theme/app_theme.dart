import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurpleAccent,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      fillColor: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
