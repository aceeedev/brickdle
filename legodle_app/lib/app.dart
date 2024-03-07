import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/pages/home_page.dart';
import 'package:legodle_app/providers/game_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<GameProvider>().getAndSetLegoSets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('An error has occurred, ${snapshot.error}'));
            } else if (snapshot.hasData) {
              context.read<GameProvider>().startGame(context);

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
