import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_first_game/overlays/main_menu.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';
import 'overlays/overlay_dashboard.dart';
import 'Game/start_game.dart';
import 'prividers/hight_score.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioProviders>(
          create: (_) => AudioProviders(),
        ),
        ChangeNotifierProvider<MyAnimatedContainers>(
          create: (_) => MyAnimatedContainers(),
        ),
        ChangeNotifierProvider<HighScore>(
          create: (_) => HighScore(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'AudioWide',
          primarySwatch: Colors.blue,
        ),
        home: const MainMenu(),
      ),
    );
  }
}

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  final game = StartGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      initialActiveOverlays: const ['Scoring'],
      overlayBuilderMap: {
        'Scoring': (BuildContext context, StartGame gameRef) {
          return OverlayDashboard(gameRef: gameRef);
        }
      },
    );
  }
}
