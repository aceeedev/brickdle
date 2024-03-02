import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/styles.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/guess.dart';

class GuessCard extends StatelessWidget {
  const GuessCard({super.key, required this.guess});

  final Guess guess;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: SizedBox(
        width: Styles(context: context).cardWidth,
        height: 45,
        child: Container(
          color: guess.color,
          // constraints: const BoxConstraints(maxWidth: 400, maxHeight: 15),
          padding: const EdgeInsets.only(right: 15.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Filler',
                    style: TextStyle(color: Colors.black.withOpacity(0))),
                Text(
                  guess.toString(),
                  style: Styles(context: context).guessTextStyle,
                ),
                Icon(
                  guess.icon,
                  color: Colors.black.withOpacity(0.25),
                  size: 35,
                ),
              ]),
        ),
      ),
    );
  }
}
