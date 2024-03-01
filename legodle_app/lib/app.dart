import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'package:legodle_app/pages/home_page.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/lego_set.dart';

class App extends StatelessWidget {
  const App({super.key});

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

              // format: [Number, Theme, Subtheme, Set name, Pieces, RRP (USD), Year]
              List<List<dynamic>> csvData =
                  const CsvToListConverter().convert(fileData);
              csvData.removeAt(0); // remove header

              List<LegoSet> legoSets =
                  csvData.map((e) => LegoSet.fromList(e)).toList();

              legoSets =
                  legoSets.where((element) => element.pieces >= 500).toList();

              context.read<GameProvider>().setLegoSets(legoSets);
              context.read<GameProvider>().startGame();

              return MaterialApp(
                title: 'Brickdle',
                theme: ThemeData(
                  fontFamily: 'Archivo Black',
                  useMaterial3: true,
                ),
                debugShowCheckedModeBanner: false,
                home: const HomePage(),
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
