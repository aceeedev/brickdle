import 'package:flutter/material.dart';
import 'dart:math';

class Styles {
  Styles({required BuildContext context}) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      _titleFontSize = 36;
      _subtitleFontSize = 24;
      _numberFontSize = 28;
      inputCardHeight = 60;
      buttonSize = 48;
    } else {
      _titleFontSize = 28;
      _subtitleFontSize = 16;
      _numberFontSize = 24;
      inputCardHeight = 45;
      buttonSize = 32;
    }
    cardWidth = min(screenWidth * 0.85, 400);
  }

  // font sizes:
  late final double _titleFontSize;
  late final double _subtitleFontSize;
  late final double _numberFontSize;

  // button sizes:
  late final double buttonSize;

  // cards:
  late double cardWidth;
  late double inputCardHeight;

  // colors:
  static const Color green = Color(0xFF29F256);
  static const Color yellow = Color(0xFFFCFF5A);
  static const Color orange = Color(0xFFF9CC2D);
  static const Color red = Color(0xFFFB5A5A);

  // text styles:
  late TextStyle titleTextStyle = TextStyle(fontSize: _titleFontSize);
  late TextStyle subtitleTextStyle = TextStyle(fontSize: _subtitleFontSize);
  late TextStyle numberTextStyle = TextStyle(fontSize: _numberFontSize);
  late TextStyle guessTextStyle = TextStyle(
      fontSize: _numberFontSize, color: Colors.black.withOpacity(0.65));
}
