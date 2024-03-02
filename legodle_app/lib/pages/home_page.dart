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

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Daily Brickdle #420',
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
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  size: Styles.iconButtonSize,
                )),
            Text(
              context.watch<GameProvider>().numOfGuesses.toString(),
              style: Styles(context: context).scoreTextStyle,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share, size: Styles.iconButtonSize),
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: Styles(context: context).cardWidth,
              // height: MediaQuery.of(context).size.width > 768 ? 60 : 40,
              height: Styles(context: context).inputCardHeight,
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
                      style: Styles(context: context).scoreTextStyle,
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
    ));
  }
}
