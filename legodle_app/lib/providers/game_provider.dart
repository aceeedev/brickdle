import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/models/guess.dart';

class GameProvider with ChangeNotifier {
  static final DateTime _firstDate = DateTime(2024, 3, 3);

  List<LegoSet> _legoSets = [];
  late LegoSet _currentLegoSet;
  int _todaysNum = 0;
  List<Guess> _guesses = [];
  int _numOfGuesses = 0;
  bool _hasWon = false;
  bool _unlimitedMode = false;

  List<LegoSet> get legoSets => _legoSets;
  LegoSet get currentLegoSet => _currentLegoSet;
  int get todaysNum => _todaysNum;
  List<Guess> get guesses => _guesses;
  int get numOfGuesses => _numOfGuesses;
  bool get hasWon => _hasWon;
  bool get unlimitedMode => _unlimitedMode;

  /// gets and sets all lego sets. Returns [true] if successful
  Future<bool> getAndSetLegoSets() async {
    String fileData =
        await rootBundle.loadString('assets/data/filtered_data.csv');

    // format: [Number, Theme, Subtheme, Set name, Pieces, RRP (USD), Year]
    List<List<dynamic>> csvData = const CsvToListConverter().convert(fileData);
    csvData.removeAt(0); // remove header

    List<LegoSet> legoSets = csvData.map((e) => LegoSet.fromList(e)).toList();

    legoSets = legoSets.where((element) => element.pieces >= 500).toList();

    _legoSets = legoSets;

    return true;
  }

  void startGame() {
    if (_unlimitedMode) {
      _currentLegoSet = legoSets[Random().nextInt(legoSets.length)];
    } else {
      final int daysAway = DateTime.now().difference(_firstDate).inDays;
      final int index = daysAway % legoSets.length;

      _todaysNum = daysAway;
      _currentLegoSet = legoSets[index];
    }

    // reset all game variables
    _guesses = [];
    _numOfGuesses = 0;
    _hasWon = false;
  }

  void addGuess(int value) {
    if (_hasWon) {
      return;
    }

    // see if guessed before
    if (!_guesses.map((e) => e.value).toList().contains(value)) {
      _numOfGuesses++;
    }

    // check if won!
    final correctValue = _currentLegoSet.pieces;
    if (value == correctValue) {
      _hasWon = true;
    }

    _guesses.insert(0, Guess(value: value, correctValue: correctValue));

    notifyListeners();
  }

  void setUnlimitedMode(bool value) {
    _unlimitedMode = value;

    notifyListeners();
  }
}
