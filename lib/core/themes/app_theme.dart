// app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 58, 64, 90),
      scaffoldBackgroundColor: const Color.fromARGB(255, 58, 64, 90),
      fontFamily: 'Roboto',
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color.fromARGB(
            255, 174, 197, 235), // Primary color (e.g., for AppBar, buttons)
        secondary: Colors.orange, // Secondary color (e.g., used for FAB)
        surface: Colors.grey[100]!, // Color for cards, modals, etc.
        error: Colors.red, // Error color (used for form validation, etc.)
        onPrimary: Colors
            .white, // Text/icons on top of primary color (e.g., white text on blue button)
        onSecondary: Colors
            .white, // Text/icons on top of secondary color (e.g., white icon on orange button)
        onSurface: Colors
            .black, // Text/icons on top of surface color (e.g., card text)
        onError: Colors.white, // Text/icons on top of error color
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 174, 197, 235),
          foregroundColor: Colors.black, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Adjust corner radius
          ),
          textStyle: const TextStyle(
              fontSize: 16, // Text size
              fontWeight: FontWeight.bold, // Text weight
              letterSpacing: 1.2, // Spacing between letters
              color: Colors.black),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white, // Adjust color for visibility
          fontSize: 16, // Adjust size as needed
        ),
        labelStyle: TextStyle(
          color: Colors.white38, // Change to desired color
          fontSize: 16, // Adjust font size
        ),
        prefixIconColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38, // Customize border color for light theme
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, // Focused border color
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Error border color
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Focused error border color
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color.fromARGB(2551, 58, 64, 90),
      scaffoldBackgroundColor: const Color.fromARGB(255, 58, 64, 90),
      fontFamily: 'Roboto',
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color.fromARGB(
            255, 174, 197, 235), // Primary color (e.g., for AppBar, buttons)
        secondary: Colors.orange, // Secondary color (e.g., used for FAB)
        surface: Colors.grey[100]!, // Color for cards, modals, etc.
        error: Colors.red, // Error color (used for form validation, etc.)
        onPrimary: Colors
            .white, // Text/icons on top of primary color (e.g., white text on blue button)
        onSecondary: Colors
            .white, // Text/icons on top of secondary color (e.g., white icon on orange button)
        onSurface: Colors
            .black, // Text/icons on top of surface color (e.g., card text)
        onError: Colors.white, // Text/icons on top of error color
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 101, 114, 136),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Adjust corner radius
          ),
          textStyle: const TextStyle(
              fontSize: 16, // Text size
              fontWeight: FontWeight.bold, // Text weight
              letterSpacing: 1.2, // Spacing between letters
              color: Colors.black),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white38, // Adjust color for visibility
          fontSize: 16, // Adjust size as needed
        ),
        labelStyle: TextStyle(
          color: Colors.white38, // Change to desired color
          fontSize: 16, // Adjust font size
        ),
        prefixIconColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38, // Customize border color for light theme
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, // Focused border color
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Error border color
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Focused error border color
          ),
        ),
      ),
    );
  }
}
