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
      color: Styles.backgroundColor,
      surfaceTintColor: Colors.transparent,
      icon: Icon(
        Icons.menu,
        size: styles.buttonSize,
        color: Styles.iconColor,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(context.read<GameProvider>().unlimitedMode
              ? '🔄 Switch To Daily Mode'
              : '🔄 Switch To Unlimited Mode'),
          onTap: () {
            context.read<GameProvider>().toggleUnlimitedMode();
            context.read<GameProvider>().startGame(context);
          },
        ),
        PopupMenuItem(
          value: 1,
          child: const Text('❓ How To Play'),
          onTap: () => _showDialog(
            context: context,
            title: 'How To Play',
            content: Text(
              'Guess the number of pieces in the set with unlimited attempts.\n▪ Each guess must be a valid number.\n▪ Your guess can be a certain threshold away and still win.\n▪ Incorrect guesses will guide you to the correct answer.\n▪ The color of the tile shows how close your guess is.\n▪ The arrow indicates if the guess is higher or lower.\n\nShare your results with friends!\nCome back each day for a new release!',
              style: styles.infoTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: const Text('📜 Disclaimer'),
          onTap: () => _showDialog(
            context: context,
            title: 'Disclaimer',
            content: Text(
              'LEGO, the LEGO logo, the Minifigure, and the Brick and Knob configurations are trademarks of the LEGO Group of Companies. ©2024 The LEGO Group.\n\nBrickdle and all content not covered by The LEGO Group\'s copyright is, unless otherwise stated, ©2024 Brickdle.',
              style: styles.infoTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: const Text('✨ Credits'),
          onTap: () => _showDialog(
            context: context,
            title: 'Credits',
            content: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Inspired by Wordle created by Josh Wardle, Brickdle is made by Andrew Collins and Riley Wong.\n\nContact us at ',
                    style: styles.infoTextStyle,
                  ),
                  TextSpan(
                    text: 'acollins2@scu.edu',
                    style: styles.infoTextStyleUnderline,
                  ),
                  TextSpan(
                    text: ' and ',
                    style: styles.infoTextStyle,
                  ),
                  TextSpan(
                    text: 'rnwong@scu.edu',
                    style: styles.infoTextStyleUnderline,
                  ),
                  TextSpan(
                    text: ' for any questions or concerns.',
                    style: styles.infoTextStyle,
                  ),
                ],
              ),
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
        final Styles styles = Styles(context: context);

        return AlertDialog(
          backgroundColor: Styles.backgroundColor,
          surfaceTintColor: Colors.transparent,
          insetPadding: styles.dialogInsetPadding,
          title: Text(title, textAlign: TextAlign.center),
          content: content,
        );
      },
    );
  }
}
