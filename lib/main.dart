import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_first_game/overlays/main_menu.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'overlays/overlay_dashboard.dart';
import 'Game/start_game.dart';
import 'prividers/hight_score.dart';

//    cd AppData\Local\Android\Sdk\platform-tools\
SharedPreferences? sp;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<String> testDeviceIds = [
    // "1eec22bc-532b-4582-993f-2db9548bc517",
    'ca-app-pub-3940256099942544~3347511713',
    '0147FBDB0745782811700C0999369E80',
    '3AF65740DDB6FAAB0DAC930A3A3FFB8C',
    "7148C7CB2EC5E96C0973AE375DC94616",
    "22B837E0B745791D726A18CFA820459E"
  ];
  await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: testDeviceIds));
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  sp = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    if ((sp?.getInt('totalCoins')) == null) {
      sp?.setInt('totalCoins', 0);
    }
    if ((sp?.getInt('bg')) == null) {
      sp?.setInt('bg', 0);
    }
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
        ChangeNotifierProvider<TabProvider>(
          create: (_) => TabProvider(),
        ),
        ChangeNotifierProvider<MapProviders>(
          create: (_) => MapProviders(),
        ),
        ChangeNotifierProvider<PlayerProviders>(
          create: (_) => PlayerProviders(),
        ),
      ],
      child: MaterialApp(
        title: 'Dino Run',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'AudioWide',
          colorSchemeSeed: const Color(0xff6750a4),
        ),
        home: MainMenu(),
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
    return WillPopScope(
      onWillPop: () async {
        game.audioComponent.stopBGM();
        return game.isPaused.value = true;
      },
      child: GameWidget(
        game: game,
        initialActiveOverlays: const ['Scoring'],
        overlayBuilderMap: {
          'Scoring': (BuildContext context, StartGame gameRef) {
            return OverlayDashboard(gameRef: gameRef);
          }
        },
      ),
    );
  }
}
