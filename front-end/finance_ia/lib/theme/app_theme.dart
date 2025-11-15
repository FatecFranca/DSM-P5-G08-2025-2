import 'package:flutter/material.dart';

class AppTheme {
  static const Color corPrincipal = Color(0xFF064C68); // Nova cor principal

  // 🌞 Tema Claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: corPrincipal, // cor principal
      onPrimary: Colors.white,
      secondary: Color(0xFFE0E0E0),
      onSecondary: Color(0xFF262626),
      error: Color(0xFFB71C1C),
      onError: Colors.white,
      surface: Color(0xFFFFFFFF), // ✅ substitui background
      onSurface: Color(0xFF262626),
      surfaceContainerHighest: Color(0xFFF2F2F2), // ✅ cor alternativa clara
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: corPrincipal,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: corPrincipal,
        side: const BorderSide(color: corPrincipal),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );

  // 🌙 Tema Escuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: corPrincipal,
      onPrimary: Colors.white,
      secondary: Color(0xFF303030),
      onSecondary: Colors.white,
      error: Color(0xFFEF5350),
      onError: Colors.white,
      surface: Color(0xFF1E1E1E), // ✅ substitui background
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF2C2C2C), // ✅ mais escuro para contraste
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: corPrincipal,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: corPrincipal,
        side: const BorderSide(color: corPrincipal),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
