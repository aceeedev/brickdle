// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/guess.dart';

class StorageManager {
  static final Storage _localStorage = window.localStorage;
  static const String _lastPlayedID = 'date';
  static const String _lastModeID = 'mode';
  static const String _guessesID = 'guesses';
  static const String _currentLegoSetIndexID = 'index';
  static const String _numOfGuessesID = 'num';

  // helper functions:
  static String _convertListToString(List<dynamic> listToConvert) {
    String convertedStr = '';

    for (int i = 0; i < listToConvert.length; i++) {
      convertedStr += listToConvert[i].toString();

      if (i != listToConvert.length - 1) {
        convertedStr += ' ';
      }
    }

    return convertedStr;
  }

  static List<dynamic> _convertStringToList(
      String strToConvert, Type convertType, BuildContext context) {
    List<dynamic> convertedList = [];

    List<String> splitStr = strToConvert.split(' ');

    switch (convertType) {
      case Guess:
        if (strToConvert == '') return <Guess>[];

        convertedList = splitStr
            .map((e) => Guess(
                value: int.parse(e),
                correctValue:
                    context.read<GameProvider>().currentLegoSet.pieces))
            .toList();
    }

    return convertedList;
  }

  static void _saveToStorage(String id, String value) =>
      _localStorage[id] = value;

  static String? _getFromStorage(String id) => _localStorage[id];

  // storage functions:
  static void saveLastPlayedDate(DateTime date) =>
      _saveToStorage(_lastPlayedID, '${date.month} ${date.day} ${date.year}');

  static DateTime? getLastPlayedDate() {
    String? dateAsStr = _getFromStorage(_lastPlayedID);
    if (dateAsStr == null) return null;

    List<int> mdyList = dateAsStr.split(' ').map((e) => int.parse(e)).toList();

    return DateTime(mdyList[2], mdyList[0], mdyList[1]);
  }

  /// Saves an int depending on the mode. 0 = daily, 1 = unlimited
  static void saveLastMode(int mode) =>
      _saveToStorage(_lastModeID, mode.toString());

  /// Returns an int depending on the mode. 0 = daily, 1 = unlimited
  static int getLastMode() => int.parse(_getFromStorage(_lastModeID)!);

  static void saveGuesses(List<Guess> guesses) {
    List<int> guessesAsInts = guesses.map((e) => e.value).toList();
    String guessesToSave = _convertListToString(guessesAsInts);

    _saveToStorage(_guessesID, guessesToSave);
  }

  static List<Guess> getGuesses(BuildContext context) {
    String? guessesAsStr = _getFromStorage(_guessesID);
    if (guessesAsStr == null) return [];

    return _convertStringToList(guessesAsStr, Guess, context) as List<Guess>;
  }

  static void saveCurrentLegoSetIndex(int index) =>
      _saveToStorage(_currentLegoSetIndexID, index.toString());

  static int getCurrentLegoSetIndex() =>
      int.parse(_getFromStorage(_currentLegoSetIndexID)!);

  static void saveNumOfGuesses(int numOfGuesses) =>
      _saveToStorage(_numOfGuessesID, numOfGuesses.toString());

  static int getNumOfGuesses() => int.parse(_getFromStorage(_numOfGuessesID)!);

  static void reset() {
    _saveToStorage(_guessesID, '');
    _saveToStorage(_numOfGuessesID, '0');
  }
}
