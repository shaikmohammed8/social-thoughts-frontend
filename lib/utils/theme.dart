import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static var light = ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: TextTheme(
        caption: TextStyle(
            fontSize: 16,
            color: Color(0xFF162545),
            fontWeight: FontWeight.w600),
        bodyText1: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontSize: 18, color: Colors.black),
        overline: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.normal),
        subtitle2: TextStyle(
            fontSize: 16,
            color: Color(0xFF162545),
            fontWeight: FontWeight.bold),
        subtitle1: TextStyle(
            fontSize: 20,
            color: Color(0xFF162545),
            fontWeight: FontWeight.w500),
        headline1: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            fontSize: 24,
            color: Color(0xFF162545),
            fontWeight: FontWeight.bold)),
    primaryColor: Color(0xFF1dbf73),
    dividerColor: Color(0xFFe5e5e5),
    shadowColor: Colors.grey[500],
    accentColor: Color(0xFF1dbf73),
    bottomAppBarColor: Colors.grey[400],
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF162545)),
    inputDecorationTheme: InputDecorationTheme(
      alignLabelWithHint: true,
      border: InputBorder.none,
      hintStyle:
          ThemeData.light().textTheme.subtitle1.copyWith(color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      toolbarTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: Color(0xFF1dbf73),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      elevation: 0.0,
    ),
  );
}

//   static var dark = ThemeData(
//       fontFamily: GoogleFonts.nunito().fontFamily,
//       textTheme: TextTheme(
//           caption: TextStyle(
//               fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//           bodyText1: TextStyle(
//               fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//           bodyText2: TextStyle(fontSize: 18, color: Colors.white),
//           overline: TextStyle(fontSize: 14, color: Colors.grey[400]),
//           subtitle2: TextStyle(
//               fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//           subtitle1: TextStyle(
//               fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
//           headline1: TextStyle(
//               fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//           headline2: TextStyle(
//               fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
//       primaryColor: Colors.blue,
//       canvasColor: Colors.grey[900],
//       primaryColorDark: Colors.black,
//       accentColor: Color(0xFF3b5773),
//       dividerColor: Colors.grey[800],
//       dialogBackgroundColor: Colors.grey[900],
//       disabledColor: Colors.grey[700],
//       iconTheme: IconThemeData(color: Colors.white),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(onSurface: Colors.white)),
//       scaffoldBackgroundColor: Colors.black,
//       inputDecorationTheme: InputDecorationTheme(
//         alignLabelWithHint: true,
//         border: InputBorder.none,
//         hintStyle:
//             ThemeData.dark().textTheme.subtitle1.copyWith(color: Colors.grey),
//       ),
//       appBarTheme: AppBarTheme(
//           titleTextStyle:
//               TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           backgroundColor: Colors.black,
//           centerTitle: true,
//           elevation: 0.0,
//           iconTheme: IconThemeData(color: Colors.blue)),
//       bottomNavigationBarTheme:
//           BottomNavigationBarThemeData(backgroundColor: Colors.black),
//       primaryIconTheme: IconThemeData(color: Colors.grey[400]));
// }
