import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_first_game/Admob/ad_helper.dart';
import 'package:my_first_game/overlays/main_menu.dart';
import 'package:my_first_game/Game/start_game.dart';
import 'package:my_first_game/SharedPref/shared_pref.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../prividers/audio_providers.dart';
import '../prividers/hight_score.dart';

class OverlayDashboard extends StatefulWidget {
  final StartGame gameRef;
  const OverlayDashboard({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<OverlayDashboard> createState() => _OverlayDashboardState();
}

class _OverlayDashboardState extends State<OverlayDashboard> {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool? isMenu;
  bool isOne = false;
  ValueNotifier<bool> isloading = ValueNotifier(false);

  int? collectedCoins;

  final Helper helper = Helper();

  Future<void> _loadInterstitialAd() async {
    return InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            setState(() {
              ad.dispose();
              _interstitialAd = null;
            });
            if (!isMenu!) {
              widget.gameRef.detach;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyGame()));
            } else {
              widget.gameRef.detach;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainMenu()),
                  (Route<dynamic> route) => false);
            }
          });
          setState(() {
            _interstitialAd = ad;
          });
        }, onAdFailedToLoad: (err) {
          debugPrint('InterstitialAd Failed to load : ${err.message}');
        }));
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            setState(() {
              ad.dispose();
              _rewardedAd = null;
            });
            if (widget.gameRef.adCounter > 2) {
              widget.gameRef.detach;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainMenu()),
                  (Route<dynamic> route) => false);
            }
            _loadRewardedAd();
          });
          setState(() {
            _rewardedAd = ad;
          });
        }, onAdFailedToLoad: (err) {
          debugPrint('Error showing rewarded ad : ${err.message}');
        }));
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void setNewCoins(coins) {
    Future.delayed(Duration.zero, () {
      MapProviders element = Provider.of<MapProviders>(context, listen: false);
      element.setCoins(coins);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: widget.gameRef.isPaused,
                  builder: (BuildContext context, value, Widget? child) {
                    return Material(
                      color: Colors.transparent,
                      child: IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            if (value) {
                              if (widget.gameRef.life.value > 0) {
                                widget.gameRef.resumeEngine();
                                widget.gameRef.audioComponent.resumeBGM();
                                widget.gameRef.isPaused.value = false;
                              }
                            } else {
                              widget.gameRef.pauseEngine();
                              widget.gameRef.audioComponent.pauseBGM();
                              widget.gameRef.isPaused.value = true;
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
                  valueListenable: widget.gameRef.life,
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
                                  child:
                                      Text('${value.highCoin} : Highest Coins'),
                                )),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
        ValueListenableBuilder(
          valueListenable: widget.gameRef.isPaused,
          builder: (BuildContext context, value, Widget? child) {
            if (widget.gameRef.life.value > 0) {
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
                          Text(
                            'Paused',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.09,
                                color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                widget.gameRef.audioComponent.stopBGM();
                                widget.gameRef.detach;
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => MainMenu()),
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
                                    isMenu = false;
                                    if (_interstitialAd != null) {
                                      isloading.value = true;
                                      _interstitialAd!.show();
                                    } else {
                                      debugPrint('InterstitialAd Not Loaded');
                                      widget.gameRef.detach;
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyGame()));
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
                                          "Restart",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ))),
                              TextButton(
                                  onPressed: () {
                                    if (widget.gameRef.life.value > 0) {
                                      widget.gameRef.resumeEngine();
                                      widget.gameRef.audioComponent.resumeBGM();
                                      widget.gameRef.isPaused.value = false;
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
          valueListenable: widget.gameRef.life,
          builder: (BuildContext context, value, Widget? child) {
            if (value <= 0) {
              int overallCoins = (sp?.getInt('totalCoins') ?? 0);
              if (widget.gameRef.adCounter == 1 && !isOne) {
                isOne = true;
                int coins = widget.gameRef.gem.value + overallCoins;
                collectedCoins = widget.gameRef.gem.value;
                setNewCoins(coins);
                helper.addCoins(widget.gameRef.gem.value);
              } else if (widget.gameRef.adCounter == 2) {
                int newCoins = widget.gameRef.gem.value - collectedCoins!;
                helper.addCoins(newCoins);
                int coins = overallCoins + newCoins;
                setNewCoins(coins);
              }
              helper.setHighest(widget.gameRef.score, widget.gameRef.gem.value);
              widget.gameRef.pauseEngine();
              widget.gameRef.audioComponent.pauseBGM();
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
                        Text(
                          'Game Over',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.1,
                              color: Colors.white),
                        ),
                        Consumer<HighScore>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Your Score: ${widget.gameRef.score}',
                                  style: const TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                (value.highScore < widget.gameRef.score)
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
                                  widget.gameRef.audioComponent.stopBGM();
                                  widget.gameRef.detach;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MainMenu()),
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
                                onPressed: () async {
                                  isMenu = false;
                                  if (_interstitialAd != null) {
                                    isloading.value = true;
                                    _interstitialAd!.show();
                                  } else {
                                    widget.gameRef.detach;
                                    debugPrint('InterstitialAd Not Loaded');
                                    widget.gameRef.detach;
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyGame()));
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
                                        "Restart",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.black),
                                      ),
                                    ))),
                          ],
                        ),
                        if (_rewardedAd != null)
                          if (widget.gameRef.adCounter == 1)
                            TextButton(
                              onPressed: () {
                                widget.gameRef.adCounter++;
                                _rewardedAd?.show(
                                    onUserEarnedReward: (_, reward) {
                                  widget.gameRef.life.value =
                                      reward.amount.toInt();
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.ondemand_video,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '2 more lifes'.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else if (widget.gameRef.adCounter == 2)
                            TextButton(
                              onPressed: () {
                                widget.gameRef.adCounter++;
                                _rewardedAd?.show(
                                    onUserEarnedReward: (_, reward) {
                                  overallCoins =
                                      (sp?.getInt('totalCoins') ?? 0);
                                  helper.addCoins(widget.gameRef.gem.value);
                                  int coins =
                                      overallCoins + (widget.gameRef.gem.value);
                                  setNewCoins(coins);
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.ondemand_video,
                                          color: Colors.black),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '2X your coins'.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox()
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        ValueListenableBuilder(
          valueListenable: isloading,
          builder: (BuildContext context, bool value, Widget? child) {
            if (value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
