import 'package:flutter/material.dart';
import 'package:legodle_app/styles.dart';

class Guess {
  final int value;
  late int _correctValue;
  late int difference;
  late int distance;
  late Color color;
  late IconData icon;

  // color settings:
  static const double _yellowCutoff = 0.3;
  static const double _orangeCutoff = 0.6;

  Guess({required this.value, required correctValue}) {
    _correctValue = correctValue;

    difference = _correctValue - value;
    distance = difference.abs();

    // determine arrow
    if (difference == 0) {
      icon = Icons.check;
      color = Styles.green;
    } else {
      if (difference < 0) {
        icon = Icons.arrow_downward;
      } else {
        icon = Icons.arrow_upward;
      }

      // determine color
      if (distance < _correctValue * _yellowCutoff) {
        color = Styles.yellow;
      } else if (distance < correctValue * _orangeCutoff) {
        color = Styles.orange;
      } else {
        color = Styles.red;
      }
    }
  }

  @override
  String toString() => value.toString();
}
