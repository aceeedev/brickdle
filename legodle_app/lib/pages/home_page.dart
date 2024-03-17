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

  List<Widget> buildGuessCards(List<Guess> guesses) {
    return guesses.map((e) => GuessCard(guess: e)).toList();
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
                          padding: const EdgeInsets.only(top: 125, bottom: 125),
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
                        onPressed: () {
                          context.read<GameProvider>().setUnlimitedMode(true);
                          context.read<GameProvider>().startGame(context);
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          size: styles.buttonSize,
                          color: Styles.iconColor,
                        ),
                      )
                    : Opacity(
                        opacity: context.read<GameProvider>().hasWon ? 1 : 0.15,
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
                                      left: (MediaQuery.of(context).size.width -
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
                      : Center(
                          child: TextFormField(
                            controller: guessTextEditingController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onFieldSubmitted: (value) {
                              final valueAsInt = int.tryParse(value);
                              if (valueAsInt != null && valueAsInt >= 1) {
                                context
                                    .read<GameProvider>()
                                    .addGuess(valueAsInt);

                                guessTextEditingController.clear();
                              }
                            },
                            textInputAction: styles.isDesktop
                                ? TextInputAction.none
                                : TextInputAction.done,
                            textAlign: TextAlign.center,
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
                              fillColor: const Color(0x0D000000),
                            ),
                          ),
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
    );
  }
}
