import 'package:flutter/material.dart';
import 'package:my_first_game/overlays/main_menu.dart';
import 'package:my_first_game/Game/start_game.dart';
import 'package:my_first_game/SharedPref/shared_pref.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../prividers/hight_score.dart';

class OverlayDashboard extends StatelessWidget {
  final StartGame gameRef;
  OverlayDashboard({Key? key, required this.gameRef}) : super(key: key);

  final Helper helper = Helper();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.isPaused,
                  builder: (BuildContext context, value, Widget? child) {
                    return Material(
                      color: Colors.transparent,
                      child: IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            if (value) {
                              if (gameRef.life.value > 0) {
                                gameRef.resumeEngine();
                                gameRef.audioComponent.resumeBGM();
                                gameRef.isPaused.value = false;
                              }
                            } else {
                              gameRef.pauseEngine();
                              gameRef.audioComponent.pauseBGM();
                              gameRef.isPaused.value = true;
                            }
                          },
                          icon: value == true
                              ? const Icon(Icons.play_arrow)
                              : const Icon(Icons.pause)
                          // icon: const Icon(Icons.pause)
                          ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: gameRef.life,
                  builder: (BuildContext context, value, Widget? child) {
                    final List<Widget> list = [];
                    for (int i = 0; i < 5; i++) {
                      list.add(i < value
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 30,
                            ));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: list,
                      ),
                    );
                  },
                ),
                Container()
              ],
            ),
            Consumer<HighScore>(
              builder: (BuildContext context, value, Widget? child) {
                return FutureBuilder(
                  future: value.getScore(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'AudioWide',
                                fontSize: 15),
                            child: Card(
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${value.highScore} : Highest'),
                                )),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Consumer<HighScore>(
              builder: (BuildContext context, value, Widget? child) {
                return FutureBuilder(
                  future: value.getScore(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'AudioWide',
                                  fontSize: 15),
                              child: Card(
                                  color: Colors.yellow,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Highest Coins: ${value.highCoin}'),
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
        ValueListenableBuilder(
          valueListenable: gameRef.isPaused,
          builder: (BuildContext context, value, Widget? child) {
            if (gameRef.life.value > 0) {
              if (value) {
                return Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.black.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80.0, vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Paused',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                gameRef.audioComponent.stopBGM();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const MainMenu()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white70,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Main Menu",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                  ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    gameRef.audioComponent.stopBGM();
                                  Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) => const MyGame()));
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Colors.white70,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Restart",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ))),
                              TextButton(
                                  onPressed: () {
                                    if (gameRef.life.value > 0) {
                                      gameRef.resumeEngine();
                                      gameRef.audioComponent.resumeBGM();
                                      gameRef.isPaused.value = false;
                                    }
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Colors.white70,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Resume",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
            return Container();
          },
        ),
        ValueListenableBuilder(
          valueListenable: gameRef.life,
          builder: (BuildContext context, value, Widget? child) {
            if (value <= 0) {
              helper.setHighest(gameRef.score, gameRef.gem.value);
              gameRef.pauseEngine();
              gameRef.audioComponent.stopBGM();
              return Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100.0, vertical: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Game Over',
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                        Consumer<HighScore>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Your Score: ${gameRef.score}',
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                (value.highScore < gameRef.score)
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Card(
                                          color: Colors.yellow,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'New Highest',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  gameRef.audioComponent.stopBGM();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainMenu()),
                                      (Route<dynamic> route) => false);
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.white70,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Main Menu",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.black),
                                      ),
                                    ))),
                            TextButton(
                                onPressed: () {
                                  gameRef.audioComponent.stopBGM();
                                  Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) => const MyGame()));
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.white70,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Restart",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.black),
                                      ),
                                    ))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
