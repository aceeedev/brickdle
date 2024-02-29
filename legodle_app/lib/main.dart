import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getDataFile() async {
    return await rootBundle.loadString('assets/data/filtered_data.csv');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDataFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An error has occurred, ${snapshot.error}'));
            } else if (snapshot.hasData) {
              String fileData = snapshot.data!;

              // format: [Number, Theme, Subtheme, Set name, Pieces, RRP (USD)]
              List<List<dynamic>> csvData =
                  const CsvToListConverter().convert(fileData);

              csvData = csvData
                  .where((element) => element[4] is int && element[4] >= 500)
                  .toList();

              final numOfLegos = csvData.length - 2;
              final selectedLego = csvData[Random().nextInt(numOfLegos) + 1];

              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: MyHomePage(selectedLego: selectedLego),
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.selectedLego});

  final List<dynamic> selectedLego;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
