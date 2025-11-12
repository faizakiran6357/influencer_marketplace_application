
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xFFB25640); // Fresh Green
//   static const Color secondaryColor = Color(0xFF1B5E20);
//   static const Color backgroundColor = Color(0xFFF8F9FA);
//   static const Color textColor = Color(0xFF212121);
//   static const Color hintColor = Colors.grey;

//   // ✅ LIGHT THEME
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: backgroundColor,
//     primaryColor: primaryColor,
//     cardColor: Colors.white, // ✅ visible on light mode
//     shadowColor: Colors.grey.shade400,
//     textTheme: GoogleFonts.poppinsTextTheme(
//       ThemeData.light().textTheme,
//     ),
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
//       hintStyle: GoogleFonts.poppins(color: Colors.grey),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         foregroundColor: Colors.white,
//         textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//       ),
//     ),
//   );

//   // ✅ DARK THEME
//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     primaryColor: primaryColor,
//     cardColor: const Color(0xFF1E1E1E), // ✅ dark visible card background
//     shadowColor: Colors.black,
//     textTheme: GoogleFonts.poppinsTextTheme(
//       ThemeData.dark().textTheme,
//     ),
//     colorScheme: const ColorScheme.dark(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFFB25640),
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFF1E1E1E),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       hintStyle: GoogleFonts.poppins(color: Colors.grey),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         foregroundColor: Colors.white,
//         textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.light().textTheme,
    ),
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
      hintStyle: GoogleFonts.roboto(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
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
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme,
    ),
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
      hintStyle: GoogleFonts.roboto(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
