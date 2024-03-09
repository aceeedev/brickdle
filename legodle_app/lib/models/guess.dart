import 'package:flutter/material.dart';
import 'package:legodle_app/styles.dart';

class Guess {
  final int value;
  late int _correctValue;
  late int difference;
  late int distance;
  late Color color;
  late IconData icon;
  late String colorEmoji;
  late String directionEmoji;

  // color settings:
  static const double _yellowCutoff = 0.1;
  static const double _orangeCutoff = 0.25;

  Guess({required this.value, required correctValue}) {
    _correctValue = correctValue;

    difference = _correctValue - value;
    distance = difference.abs();

    // determine arrow
    if (difference == 0) {
      icon = Icons.check;
      color = Styles.green;
      colorEmoji = '🟩';
      directionEmoji = '✅';
    } else {
      if (difference < 0) {
        icon = Icons.arrow_downward;
        directionEmoji = '⬇️';
      } else {
        icon = Icons.arrow_upward;
        directionEmoji = '⬆️';
      }

      // determine color
      if (distance < _correctValue * _yellowCutoff) {
        color = Styles.yellow;
        colorEmoji = '🟨';
      } else if (distance < correctValue * _orangeCutoff) {
        color = Styles.orange;
        colorEmoji = '🟧';
      } else {
        color = Styles.red;
        colorEmoji = '🟥';
      }
    }
  }

  @override
  String toString() => value.toString();
}
