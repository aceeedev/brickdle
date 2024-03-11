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
            content: Text(
              'abc',
              textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
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
