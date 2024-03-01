import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/styles.dart';
import 'package:legodle_app/providers/game_provider.dart';

class GuessCard extends StatelessWidget {
  const GuessCard({super.key, required this.guess});

  final int guess;

  @override
  Widget build(BuildContext context) {
    int correctValue = context.read<GameProvider>().currentLegoSet.pieces;
    int distanceAway = correctValue - guess;

    late final IconData icon;
    late final Color cardColor;

    if (distanceAway == 0) {
      icon = Icons.check;
      cardColor = Styles.correctColor;
    } else {
      if (distanceAway < 0) {
        icon = Icons.arrow_downward;
      } else {
        icon = Icons.arrow_upward;
      }

      if ((distanceAway).abs() < correctValue * 0.1) {
        cardColor = Styles.closeColor;
      } else if ((distanceAway).abs() < correctValue * 0.3) {
        cardColor = Styles.farColor;
      } else {
        cardColor = Styles.distantColor;
      }
    }

    final Widget directionIcon = Icon(
      icon,
      color: Colors.black.withOpacity(0.50),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: 400,
        height: 60,
        child: Container(
          color: cardColor,
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 60),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                directionIcon,
                Text(
                  guess.toString(),
                  style: Styles.scoreTextStyle,
                ),
                directionIcon,
              ]),
        ),
      ),
    );
  }
}
