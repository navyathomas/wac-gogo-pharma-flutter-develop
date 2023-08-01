import 'package:flutter/material.dart';

class ColorPalette {
  static  Color get primaryColor => const Color(0xFF00CBC0);
  static Color get bgColor => const Color(0xFFF4F7F7);
  static Color get grey => const Color(0xFFE3E3E3);
  static Color get lightGrey => const Color(0xFFF7F7F7);
  static Color get shimmerHighlightColor => const Color(0xFFEDF5F5);
  static Color get shimmerBaseColor => const Color(0xFFF4F7F7);

  //colors in login.dart
  static Color get dimGrey => const Color(0xFF9FAEBB);
  static Color get slightDarkGrey => const Color(0xFF556879);
  static Color get borderGrey => const Color(0xFFBAD0CE);

//colors of product_list.dart
  static Color get borderGreenGrey => const Color(0xFFD9E3E3);

  static const MaterialColor materialPrimary = MaterialColor(
    0xFF00CBC0,
    <int, Color>{
      50: Color(0xFF00CBC0),
      100: Color(0xFF00CBC0),
      200: Color(0xFF00CBC0),
      300: Color(0xFF00CBC0),
      400: Color(0xFF00CBC0),
      500: Color(0xFF00CBC0),
      600: Color(0xFF00CBC0),
      700: Color(0xFF00CBC0),
      800: Color(0xFF00CBC0),
      900: Color(0xFF00CBC0),
    },
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
