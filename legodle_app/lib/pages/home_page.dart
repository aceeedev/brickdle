import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/styles.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:legodle_app/models/lego_set.dart';
import 'package:legodle_app/models/guess.dart';
import 'package:legodle_app/widgets/guess_card_widget.dart';
import 'package:legodle_app/widgets/hamburger_menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController guessTextEditingController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Widget> buildGuessCards(List<Guess> guesses) {
    return guesses.map((e) => GuessCard(guess: e)).toList();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LegoSet currentLegoSet = context.watch<GameProvider>().currentLegoSet;
    List<Guess> guesses = context.watch<GameProvider>().guesses;
    final Styles styles = Styles(context: context);

    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Focus(
            focusNode: _focusNode,
            onKeyEvent: _handleKeyEvent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.read<GameProvider>().unlimitedMode
                      ? 'Brickdle Unlimited'
                      : 'Daily Brickdle #${context.read<GameProvider>().todaysNum}',
                  style: styles.titleTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Image.network(
                  currentLegoSet.imageUrl,
                  fit: BoxFit.fitWidth,
                  height: 300,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: SizedBox(
                          width: 50,
                          height: 300,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 125, bottom: 125),
                            child: CircularProgressIndicator(
                              color: Colors.black.withOpacity(0.2),
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Text(
                  '${currentLegoSet.name} ${currentLegoSet.hasSubtheme ? '(${currentLegoSet.theme})' : ''}',
                  style: styles.subtitleTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const HamburgerMenu(),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, left: 32),
                    child: Text(
                      context.watch<GameProvider>().numOfGuesses.toString(),
                      style: styles.numberTextStyle,
                    ),
                  ),
                  context.read<GameProvider>().unlimitedMode
                      ? IconButton(
                          tooltip: 'Next Set',
                          onPressed: () => _nextUnlimitedSet(),
                          icon: Icon(
                            Icons.arrow_forward,
                            size: styles.buttonSize,
                            color: Styles.iconColor,
                          ),
                        )
                      : Opacity(
                          opacity:
                              context.read<GameProvider>().hasWon ? 1 : 0.15,
                          child: IconButton(
                            tooltip: 'Share',
                            onPressed: context.read<GameProvider>().hasWon
                                ? () {
                                    Clipboard.setData(ClipboardData(
                                        text: context
                                            .read<GameProvider>()
                                            .shareResults()));
                                    var snackBar = SnackBar(
                                      content: const Center(
                                          child: Text('Copied to Clipboard!')),
                                      dismissDirection: DismissDirection.none,
                                      // animation: AnimationController(vsync: none),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                                100,
                                        left:
                                            (MediaQuery.of(context).size.width -
                                                    200) /
                                                2,
                                        right:
                                            (MediaQuery.of(context).size.width -
                                                    200) /
                                                2,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                : null,
                            icon: Icon(
                              Icons.share,
                              size: styles.buttonSize,
                              color: Styles.iconColor,
                            ),
                          ),
                        )
                ]),
                if (context.watch<GameProvider>().unlimitedMode &&
                    context
                            .watch<GameProvider>()
                            .averageNumGuessesInUnlimitedMode !=
                        0)
                  Text(
                    'Your average guesses: ${context.watch<GameProvider>().averageNumGuessesInUnlimitedMode.toStringAsFixed(2)}',
                    style: styles.subtitleTextStyle,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: styles.cardWidth,
                    // height: MediaQuery.of(context).size.width > 768 ? 60 : 40,
                    height: styles.inputCardHeight,
                    child: context.watch<GameProvider>().hasWon
                        ? Text(
                            '🎉 You won!! 🎉',
                            style: styles.titleTextStyle,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          )
                        : Row(
                            children: [
                              SizedBox(
                                height: styles.inputCardHeight,
                                width: styles.cardWidth * 0.7,
                                child: TextFormField(
                                  controller: guessTextEditingController,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onFieldSubmitted: (value) =>
                                      _submitGuess(value),
                                  textInputAction: styles.isDesktop
                                      ? TextInputAction.none
                                      : TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: 1,
                                  style: styles.numberTextStyle,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'How many bricks?',
                                    hintStyle: styles.subtitleTextStyle,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    fillColor: const Color(0x0D000000),
                                  ),
                                ),
                              ),
                              SizedBox(width: styles.cardWidth * 0.02),
                              SizedBox(
                                height: styles.inputCardHeight,
                                width: styles.cardWidth * 0.28,
                                child: TextButton(
                                  onPressed: () => _submitGuess(
                                      guessTextEditingController.text),
                                  style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        width: 2, color: Color(0x40000000)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    foregroundColor: const Color(0xFF444444),
                                  ),
                                  child: Text('Enter',
                                      style: styles.subtitleTextStyle),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                ...buildGuessCards(guesses),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitGuess(String guess) {
    final valueAsInt = int.tryParse(guess);

    if (valueAsInt != null && valueAsInt >= 1) {
      context.read<GameProvider>().addGuess(valueAsInt);

      guessTextEditingController.clear();
    }

    if (context.read<GameProvider>().hasWon &&
        context.read<GameProvider>().unlimitedMode) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _nextUnlimitedSet() {
    context.read<GameProvider>().setUnlimitedMode(true);
    context.read<GameProvider>().startGame(context);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        context.read<GameProvider>().hasWon &&
        context.read<GameProvider>().unlimitedMode &&
        event.physicalKey == PhysicalKeyboardKey.enter) {
      _nextUnlimitedSet();

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
