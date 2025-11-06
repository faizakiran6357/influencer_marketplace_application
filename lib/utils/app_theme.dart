// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xFF00C853); // Fresh Green
//   static const Color secondaryColor = Color(0xFF1B5E20);
//   static const Color backgroundColor = Color(0xFFF8F9FA);
//   static const Color textColor = Color(0xFF212121);
//   static const Color hintColor = Colors.grey;

//   static ThemeData lightTheme = ThemeData(
//     scaffoldBackgroundColor: backgroundColor,
//     primaryColor: primaryColor,
//     colorScheme: const ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       hintStyle: const TextStyle(color: Colors.grey),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         foregroundColor: Colors.white,
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//   );
// }
// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xFF00C853); // Fresh Green
//   static const Color secondaryColor = Color(0xFF1B5E20);
//   static const Color backgroundColor = Color(0xFFF8F9FA);
//   static const Color textColor = Color(0xFF212121);
//   static const Color hintColor = Colors.grey;

//   // ---------------- LIGHT THEME ----------------
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: backgroundColor,
//     primaryColor: primaryColor,
//     colorScheme: const ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       hintStyle: const TextStyle(color: Colors.grey),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         foregroundColor: Colors.white,
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     floatingActionButtonTheme:
//         const FloatingActionButtonThemeData(backgroundColor: primaryColor),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: textColor),
//       bodyMedium: TextStyle(color: textColor),
//       bodySmall: TextStyle(color: textColor),
//     ),
//   );

//   // ---------------- DARK THEME ----------------
//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     primaryColor: primaryColor,
//     colorScheme: const ColorScheme.dark(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF1B5E20),
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Color(0xFF1E1E1E),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       hintStyle: const TextStyle(color: Colors.white54),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         foregroundColor: Colors.white,
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     floatingActionButtonTheme:
//         const FloatingActionButtonThemeData(backgroundColor: primaryColor),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white),
//       bodyMedium: TextStyle(color: Colors.white70),
//       bodySmall: TextStyle(color: Colors.white60),
//     ),
//   );
// }
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFB25640); // Fresh Green
  static const Color secondaryColor = Color(0xFF1B5E20);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color textColor = Color(0xFF212121);
  static const Color hintColor = Colors.grey;

  // ✅ LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    cardColor: Colors.white, // ✅ visible on light mode
    shadowColor: Colors.grey.shade400,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );

  // ✅ DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: primaryColor,
    cardColor: const Color(0xFF1E1E1E), // ✅ dark visible card background
    shadowColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB25640),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
