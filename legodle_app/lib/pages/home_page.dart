import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/lego_set.dart';

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
          const Text('Daily Brickdle #420'),
          Image.network(
              'https://images.brickset.com/sets/images/${currentLegoSet.number}.jpg',
              fit: BoxFit.fitWidth,
              height: 300),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            Text('${currentLegoSet.name} (${currentLegoSet.subtheme})'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  final valueAsInt = int.tryParse(value);
                  if (valueAsInt != null) {
                    context.read<GameProvider>().addGuess(valueAsInt);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your guess',
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 100,
              child: ListView.builder(
                  itemCount: guesses.length,
                  itemBuilder: (context, index) {
                    int guess = guesses[index];
                    int correctValue = currentLegoSet.pieces;

                    IconData icon = guess == correctValue
                        ? Icons.check
                        : guess > correctValue
                            ? Icons.arrow_downward
                            : Icons.arrow_upward;

                    return SizedBox(
                      child: Row(children: [
                        Icon(icon),
                        Text(guess.toString()),
                        Icon(icon)
                      ]),
                    );
                  }),
            ),
          )
        ],
      ),
    ));
  }
}
