import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:legodle_app/pages/home_page.dart';

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
                home: HomePage(selectedLego: selectedLego),
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
