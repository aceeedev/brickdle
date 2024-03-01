import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/app.dart';
import 'package:legodle_app/providers/game_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GameProvider()),
  ], child: const App()));
}
