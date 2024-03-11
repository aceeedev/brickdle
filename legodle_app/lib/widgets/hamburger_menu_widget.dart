import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/styles.dart';
import 'package:legodle_app/providers/game_provider.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final Styles styles = Styles(context: context);

    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        size: styles.buttonSize,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(context.read<GameProvider>().unlimitedMode
              ? 'Switch To Daily Mode'
              : 'Switch To Unlimited Mode'),
          onTap: () {
            context.read<GameProvider>().toggleUnlimitedMode();
            context.read<GameProvider>().startGame(context);
          },
        ),
        PopupMenuItem(
          value: 1,
          child: const Text('How To Play'),
          onTap: () => _showDialog(
            context: context,
            title: 'How To Play',
            content: const Text(
              'Guess the number of pieces in the set with unlimited attempts.\n▪ Each guess must be a valid number.\n▪ Your guess can be a certain threshold away and still win.\n▪ Incorrect guesses will guide you to the correct answer.\n▪ The color of the tile shows how close your guess is.\n▪ The arrow indicates if the guess is higher or lower.\n\nShare your results with friends!\nCome back each day for a new release!',
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: const Text('Disclaimer'),
          onTap: () => _showDialog(
            context: context,
            title: 'Disclaimer',
            content: const Text(
              'LEGO, the LEGO logo, the Minifigure, and the Brick and Knob configurations are trademarks of the LEGO Group of Companies. ©2024 The LEGO Group.',
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: const Text('Credits'),
          onTap: () => _showDialog(
            context: context,
            title: 'Credits',
            content: const Text(
              'Inspired by Wordle created by Josh Wardle, Brickdle is made by Andrew Collins and Riley Wong.',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDialog(
      {required BuildContext context,
      required String title,
      required Widget content}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: Styles(context: context).dialogInsetPadding,
          title: Text(title, textAlign: TextAlign.center),
          content: content,
        );
      },
    );
  }
}
