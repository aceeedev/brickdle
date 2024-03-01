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
  @override
  Widget build(BuildContext context) {
    LegoSet currentLegoSet = context.watch<GameProvider>().currentLegoSet;
    List<int> guesses = context.watch<GameProvider>().guesses;

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Daily Brickdle #420',
            style: Styles.titleTextStyle,
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
            Text(
              '${currentLegoSet.name} ${currentLegoSet.hasSubtheme ? '(${currentLegoSet.subtheme})' : ''}',
              style: Styles.subtitleTextStyle,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, size: Styles.iconButtonSize))
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 75,
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
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Enter your guess',
                    hintStyle: Styles.subtitleTextStyle,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5)),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 400,
              height: 60,
              child: ListView.builder(
                  itemCount: guesses.length,
                  itemBuilder: (context, index) {
                    int guess = guesses[index];

                    return GuessCard(guess: guess);
                  }),
            ),
          )
        ],
      ),
    ));
  }
}
