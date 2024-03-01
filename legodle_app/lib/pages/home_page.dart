import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/styles.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/widgets/guess_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> buildGuessCards(List<int> guesses) {
    return guesses.map((e) => GuessCard(guess: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    LegoSet currentLegoSet = context.watch<GameProvider>().currentLegoSet;
    List<int> guesses = context.watch<GameProvider>().guesses;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Daily Brickdle #420',
            style: Styles.titleTextStyle,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          Image.network(currentLegoSet.imageUrl,
              fit: BoxFit.fitWidth, height: 300),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  size: Styles.iconButtonSize,
                )),
            Flexible(
              child: Text(
                '${currentLegoSet.name} ${currentLegoSet.hasSubtheme ? '(${currentLegoSet.subtheme})' : ''}',
                style: Styles.subtitleTextStyle,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, size: Styles.iconButtonSize))
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 60,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  final valueAsInt = int.tryParse(value);
                  if (valueAsInt != null) {
                    context.read<GameProvider>().addGuess(valueAsInt);
                  }
                },
                textInputAction: TextInputAction.none,
                textAlign: TextAlign.center,
                style: Styles.scoreTextStyle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'How many bricks?',
                  hintStyle: Styles.subtitleTextStyle,
                  filled: true,
                  fillColor: const Color(0x0D000000),
                ),
              ),
            ),
          ),
          ...buildGuessCards(guesses),
        ],
      ),
    ));
  }
}
