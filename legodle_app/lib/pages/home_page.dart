import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.selectedLego});

  final List<dynamic> selectedLego;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> guesses = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  'https://images.brickset.com/sets/images/${widget.selectedLego[0]}.jpg',
                  fit: BoxFit.fitWidth,
                  height: 500),
              TextFormField(
                onFieldSubmitted: (value) =>
                    setState(() => guesses.insert(0, int.parse(value))),
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: guesses.length,
                      itemBuilder: (context, index) {
                        int guess = guesses[index];
                        int correctValue = widget.selectedLego[4];

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
