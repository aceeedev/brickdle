import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:legodle_app/backend/storage_manager.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/models/guess.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class GameProvider with ChangeNotifier {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static final DateTime _firstDate = DateTime(2024, 3, 11);

  List<LegoSet> _legoSets = [];
  late LegoSet _currentLegoSet;
  int _currentLegoSetIndex = 0;
  int _todaysNum = 0;
  List<Guess> _guesses = [];
  int _numOfGuesses = 0;
  bool _hasWon = false;
  bool _unlimitedMode = false;
  final List<int> _numGuessesInUnlimitedMode = [];

  int get _lastMode => _unlimitedMode ? 1 : 0;
  int get _correctValue => _currentLegoSet.pieces;

  List<LegoSet> get legoSets => _legoSets;
  LegoSet get currentLegoSet => _currentLegoSet;
  int get todaysNum => _todaysNum;
  List<Guess> get guesses => _guesses;
  int get numOfGuesses => _numOfGuesses;
  bool get hasWon => _hasWon;
  bool get unlimitedMode => _unlimitedMode;
  double get averageNumGuessesInUnlimitedMode {
    if (_numGuessesInUnlimitedMode.isEmpty) return 0;
    int length = _numGuessesInUnlimitedMode.length;
    int sum = _numGuessesInUnlimitedMode.reduce((a, b) => a + b);

    return sum / length;
  }

  /// gets and sets all lego sets. Returns [true] if successful
  Future<bool> getAndSetLegoSets() async {
    String fileData =
        await rootBundle.loadString('assets/data/filtered_data.csv');

    // format: [Number, Theme, Subtheme, Set name, Pieces, RRP (USD), Year]
    List<String> csvRows = fileData.split('\n');
    csvRows.removeAt(0); // remove header
    csvRows.removeLast(); // remove empty last line

    List<LegoSet> legoSets =
        csvRows.map((e) => LegoSet.fromList(e.split(','))).toList();

    _legoSets = legoSets;

    return true;
  }

  /// Returns [bool] if the day, month, and year matches
  bool sameDate(DateTime firstDate, DateTime secondDate) =>
      firstDate.day == secondDate.day &&
      firstDate.month == secondDate.month &&
      firstDate.year == secondDate.year;

  void checkIfWon(int value) {
    double threshold = max(3, min(_correctValue * 0.01, 25));
    if (_correctValue - threshold <= value &&
        value <= _correctValue + threshold) {
      _hasWon = true;
      _guesses[0] = Guess(value: _correctValue, correctValue: _correctValue);

      // save if in unlimited mode for average calculation
      if (_unlimitedMode) {
        _numGuessesInUnlimitedMode.add(_numOfGuesses);
      }
    }
  }

  void _reset() {
    _guesses = [];
    _numOfGuesses = 0;
    _hasWon = false;

    StorageManager.reset();
  }

  void _initDailyMode() {
    final int daysAway = DateTime.now().difference(_firstDate).inDays;
    _currentLegoSetIndex = daysAway % legoSets.length;

    _todaysNum = daysAway;
  }

  void startGame(BuildContext context) {
    // see if game should be resumed
    DateTime? lastPlayed = StorageManager.getLastPlayedDate();

    // has played before, set to last state
    if (lastPlayed != null) {
      int modeLastPlayed = StorageManager.getLastMode();

      // set mode
      switch (modeLastPlayed) {
        // daily mode
        case 0:
          _unlimitedMode = false;

        // unlimited mode
        case 1:
          _unlimitedMode = true;
      }

      // check if it is a new day
      if (sameDate(DateTime.now(), lastPlayed)) {
        // resume current lego set
        if (_unlimitedMode) {
          _currentLegoSetIndex = StorageManager.getCurrentLegoSetIndex();
        } else {
          _initDailyMode();
        }

        _currentLegoSet = legoSets[_currentLegoSetIndex];

        // restore state
        _guesses = StorageManager.getGuesses(context);
        _numOfGuesses = StorageManager.getNumOfGuesses();

        if (_guesses.isNotEmpty) checkIfWon(_guesses.first.value);
      } else {
        _reset();
      }
    } else {
      // has not played before
      // reset all game variables
      _reset();

      StorageManager.saveCurrentLegoSetIndex(Random().nextInt(legoSets.length));
    }

    if (!_unlimitedMode) {
      _initDailyMode();

      _currentLegoSet = legoSets[_currentLegoSetIndex];
    }

    // save to storage
    StorageManager.saveLastMode(_lastMode);
    StorageManager.saveLastPlayedDate(DateTime.now());
    StorageManager.saveNumOfGuesses(_numOfGuesses);
  }

  void addGuess(int value) {
    if (_hasWon) {
      return;
    }

    // see if guessed before
    if (!_guesses.map((e) => e.value).toList().contains(value)) {
      _numOfGuesses++;
      _guesses.insert(0, Guess(value: value, correctValue: _correctValue));
    }

    // check if won!
    checkIfWon(value);

    notifyListeners();
    StorageManager.saveGuesses(_guesses);
    StorageManager.saveNumOfGuesses(_numOfGuesses);
  }

  void setUnlimitedMode(bool value) {
    if (value) {
      _currentLegoSetIndex = Random().nextInt(legoSets.length);
      _currentLegoSet = legoSets[_currentLegoSetIndex];
      // analytics
      analytics.logEvent(
        name: 'unlimited_mode',
        parameters: {
          'current_set': _currentLegoSet.name,
          'played_again': (_unlimitedMode == value) ? 1 : 0,
        },
      );
    }

    _unlimitedMode = value;

    _reset();

    notifyListeners();
    StorageManager.saveLastMode(_lastMode);
    StorageManager.saveCurrentLegoSetIndex(_currentLegoSetIndex);
  }

  void toggleUnlimitedMode() {
    setUnlimitedMode(!_unlimitedMode);
  }

  String shareResults() {
    String share = '${guesses[0].colorEmoji}${guesses[0].directionEmoji}';
    for (int i = 1; i < guesses.length; i++) {
      share = '${guesses[i].colorEmoji}${guesses[i].directionEmoji}\n$share';
    }
    share =
        '🧱 Daily Brickdle #$_todaysNum 🧱\n🔎 ${_currentLegoSet.name}\n💡 $_numOfGuesses Guesses\n$share\nPlay at https://brickdle.com';
    // analytics
    analytics.logEvent(
      name: 'share_results',
      parameters: {
        'daily_number': _todaysNum,
        'set_name': _currentLegoSet.name,
        'set_pieces': _currentLegoSet.pieces,
        'num_guesses': _numOfGuesses,
        'guesses': _guesses.join(','),
        'share_text': share,
      },
    );
    return share;
  }
}
