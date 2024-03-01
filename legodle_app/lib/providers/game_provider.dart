import 'dart:math';
import 'package:flutter/material.dart';
import 'package:legodle_app/models/lego_set.dart';

class GameProvider with ChangeNotifier {
  List<LegoSet> _legoSets = [];
  late LegoSet _currentLegoSet;
  List<int> _guesses = [];

  List<LegoSet> get legoSets => _legoSets;
  LegoSet get currentLegoSet => _currentLegoSet;
  List<int> get guesses => _guesses;

  void setLegoSets(List<LegoSet> value) {
    _legoSets = value;
  }

  void startGame() {
    _currentLegoSet = legoSets[Random().nextInt(legoSets.length)];
    _guesses = [];
  }

  void addGuess(int value) {
    _guesses.insert(0, value);

    notifyListeners();
  }
}
