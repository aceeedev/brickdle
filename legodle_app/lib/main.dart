import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:legodle_app/app.dart';
import 'package:legodle_app/providers/game_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GameProvider()),
  ], child: const App()));
}
