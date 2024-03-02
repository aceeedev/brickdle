import 'package:flutter/material.dart';

class Styles {
  Styles({required BuildContext context}) {
    if (MediaQuery.of(context).size.width > 768) {
      _titleFontSize = 36;
      _subtitleFontSize = 24;
      _scoreFontSize = 28;
    } else {
      _titleFontSize = 18;
      _subtitleFontSize = 14;
      _scoreFontSize = 16;
    }
  }

  // font sizes:
  late final double _titleFontSize;
  late final double _subtitleFontSize;
  late final double _scoreFontSize;

  // colors:
  static const Color correctColor = Color(0xFF11E440);
  static const Color closeColor = Color(0xFFF6F950);
  static const Color farColor = Color(0xFFFFA500);
  static const Color distantColor = Color(0xFFFB5A5A);

  // text styles:
  late TextStyle titleTextStyle = TextStyle(fontSize: _titleFontSize);
  late TextStyle subtitleTextStyle = TextStyle(fontSize: _subtitleFontSize);
  late TextStyle scoreTextStyle = TextStyle(fontSize: _scoreFontSize);

  // misc:
  static const double iconButtonSize = 48;
}
