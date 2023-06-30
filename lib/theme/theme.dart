import 'package:flutter/material.dart';

Map<int, Color> mainColor = {
  50: const Color(0xfff66118),
  100: const Color(0xfff66118),
  200: const Color(0xfff66118),
  300: const Color(0xfff66118),
  400: const Color(0xfff66118),
  500: const Color(0xfff66118),
  600: const Color(0xfff66118),
  700: const Color(0xfff66118),
  800: const Color(0xfff66118),
  900: const Color(0xfff66118),
};
MaterialColor mycolor = MaterialColor(0xfff66118, mainColor);

class AppTheme {
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color primaryColor = Color(0xfff66118);
  static MaterialColor primarySwatch = mycolor;
  static ColorScheme colorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0xfff66118));

  static const Color iconColor = Colors.white;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color iconColorDisable = Color.fromARGB(255, 160, 159, 159);
  static const Color textColor = Colors.white;
  static const Color myLocationIconColor = Color(0xfff66118);
  static const Color trashCanPointColor = Color.fromARGB(255, 0, 82, 18);
  static const Color isFullTrash = Color(0xfff66118);
  static const Color ishalfEmptyTrash = Color.fromARGB(255, 0, 82, 18);
  static const Color isEmptyTrash = Color.fromARGB(255, 255, 0, 0);
}
