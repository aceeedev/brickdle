// ignore_for_file: undefined_getter

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/Styles.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/models/guess.dart';
import 'package:legodle_app/widgets/guess_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController guessTextEditingController =
      TextEditingController();

  List<Widget> buildGuessCards(List<Guess> guesses) {
    return guesses.map((e) => GuessCard(guess: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    LegoSet currentLegoSet = context.watch<GameProvider>().currentLegoSet;
    List<Guess> guesses = context.watch<GameProvider>().guesses;
    final Styles styles = Styles(context: context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.read<GameProvider>().unlimitedMode
                  ? 'Brickdle Unlimited'
                  : 'Daily Brickdle #${context.read<GameProvider>().todaysNum}',
              style: Styles(context: context).titleTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            Image.network(currentLegoSet.imageUrl,
                fit: BoxFit.fitWidth, height: 300),
            Text(
              '${currentLegoSet.name} ${currentLegoSet.hasSubtheme ? '(${currentLegoSet.subtheme})' : ''}',
              style: Styles(context: context).subtitleTextStyle,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  onPressed: () {
                    context.read<GameProvider>().toggleUnlimitedMode();
                    context.read<GameProvider>().startGame(context);
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: Styles.iconButtonSize,
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  context.watch<GameProvider>().numOfGuesses.toString(),
                  style: styles.numberTextStyle,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, size: Styles.iconButtonSize),
              )
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: styles.cardWidth,
                // height: MediaQuery.of(context).size.width > 768 ? 60 : 40,
                height: styles.inputCardHeight,
                child: context.watch<GameProvider>().hasWon
                    ? Text(
                        '🎉 You won!! 🎉',
                        style: Styles(context: context).titleTextStyle,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      )
                    : TextFormField(
                        controller: guessTextEditingController,
                        onFieldSubmitted: (value) {
                          final valueAsInt = int.tryParse(value);
                          if (valueAsInt != null) {
                            context.read<GameProvider>().addGuess(valueAsInt);

                            guessTextEditingController.clear();
                          }
                        },
                        textInputAction: TextInputAction.none,
                        textAlign: TextAlign.center,
                        style: styles.numberTextStyle,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'How many bricks?',
                          hintStyle: Styles(context: context).subtitleTextStyle,
                          filled: true,
                          fillColor: const Color(0x0D000000),
                        ),
                      ),
              ),
            ),
            ...buildGuessCards(guesses),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    ));
  }
}
