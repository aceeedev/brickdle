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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Guess the number of lego pieces!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  'https://images.brickset.com/sets/images/${currentLegoSet.number}.jpg',
                  fit: BoxFit.fitWidth,
                  height: 500),
              TextFormField(
                onFieldSubmitted: (value) =>
                    context.read<GameProvider>().addGuess(int.parse(value)),
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: guesses.length,
                      itemBuilder: (context, index) {
                        int guess = guesses[index];
                        int correctValue = currentLegoSet.pieces;

                        IconData icon = guess == correctValue
                            ? Icons.check
                            : guess > correctValue
                                ? Icons.arrow_downward
                                : Icons.arrow_upward;

                        return Container(
                          width: 500,
                          height: 40,
                          child: Card(
                              child: Row(children: [
                            Text(guess.toString()),
                            Icon(icon)
                          ])),
                        );
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
