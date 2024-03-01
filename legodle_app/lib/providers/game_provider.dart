import 'dart:math';
import 'package:flutter/material.dart';
import 'package:legodle_app/models/lego_set.dart';

class GameProvider with ChangeNotifier {
  List<LegoSet> _legoSets = [];
  late LegoSet _currentLegoSet;
  List<int> _guesses = [];
  int _numOfGuesses = 0;
  bool _hasWon = false;

  List<LegoSet> get legoSets => _legoSets;
  LegoSet get currentLegoSet => _currentLegoSet;
  List<int> get guesses => _guesses;
  int get numOfGuesses => _numOfGuesses;
  bool get hasWon => _hasWon;

  void setLegoSets(List<LegoSet> value) {
    _legoSets = value;
  }

  void startGame() {
    _currentLegoSet = legoSets[Random().nextInt(legoSets.length)];

    // reset all game variables
    _guesses = [];
    _numOfGuesses = 0;
    _hasWon = false;
  }

  void addGuess(int value) {
    if (_hasWon) {
      return;
    }

    if (!_guesses.contains(value)) {
      _numOfGuesses++;
    }

    // check if won!
    if (value == _currentLegoSet.pieces) {
      _hasWon = true;
    }

    _guesses.insert(0, value);

    notifyListeners();
  }
}
