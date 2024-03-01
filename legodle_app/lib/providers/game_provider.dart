import 'dart:math';
import 'package:flutter/material.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/models/guess.dart';

class GameProvider with ChangeNotifier {
  List<LegoSet> _legoSets = [];
  late LegoSet _currentLegoSet;
  List<Guess> _guesses = [];
  int _numOfGuesses = 0;
  bool _hasWon = false;

  List<LegoSet> get legoSets => _legoSets;
  LegoSet get currentLegoSet => _currentLegoSet;
  List<Guess> get guesses => _guesses;
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
}
