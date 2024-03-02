import 'package:flutter/material.dart';
import 'dart:math';

class Styles {
  Styles({required BuildContext context}) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      _titleFontSize = 36;
      _subtitleFontSize = 24;
      _scoreFontSize = 28;
      inputCardHeight = 60;
    } else {
      _titleFontSize = 28;
      _subtitleFontSize = 16;
      _scoreFontSize = 24;
      inputCardHeight = 45;
    }
    cardWidth = min(screenWidth * 0.85, 400);
  }

  // font sizes:
  late final double _titleFontSize;
  late final double _subtitleFontSize;
  late final double _scoreFontSize;

  // cards:
  late final double cardWidth;
  late final double inputCardHeight;

  // colors:
  static const Color green = Color(0xFF11E440);
  static const Color yellow = Color(0xFFFCFF5A);
  static const Color orange = Color(0xFFF9CC2D);
  static const Color red = Color(0xFFFB5A5A);

  // text styles:
  late TextStyle titleTextStyle = TextStyle(fontSize: _titleFontSize);
  late TextStyle subtitleTextStyle = TextStyle(fontSize: _subtitleFontSize);
  late TextStyle scoreTextStyle = TextStyle(fontSize: _scoreFontSize);

  // misc:
  static const double iconButtonSize = 48;
}
