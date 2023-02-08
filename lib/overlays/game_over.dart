// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';

// import '../Game/start_game.dart';
// import '../main.dart';
// import '../prividers/hight_score.dart';
// import 'main_menu.dart';

// // ignore: must_be_immutable
// class GameOver extends StatelessWidget {
//   final StartGame gameRef;
//   final InterstitialAd? interstitialAd;
//   final RewardedAd? rewardedAd;
//   bool? isMenu;
//   GameOver(
//       {super.key,
//       required this.gameRef,
//       required this.interstitialAd,
//       required this.rewardedAd,
//       required this.isMenu});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   color: Colors.black.withOpacity(0.4),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 100.0, vertical: 50),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const Text(
//                           'Game Over',
//                           style: TextStyle(fontSize: 50, color: Colors.white),
//                         ),
//                         Consumer<HighScore>(
//                           builder:
//                               (BuildContext context, value, Widget? child) {
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'Your Score: ${gameRef.score}',
//                                   style: const TextStyle(
//                                       fontSize: 30, color: Colors.white),
//                                 ),
//                                 (value.highScore < gameRef.score)
//                                     ? const Padding(
//                                         padding: EdgeInsets.only(left: 8.0),
//                                         child: Card(
//                                           color: Colors.yellow,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Text(
//                                               'New Highest',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     : Container()
//                               ],
//                             );
//                           },
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             TextButton(
//                                 onPressed: () {
//                                   isMenu = true;
//                                   if (interstitialAd != null) {
//                                     interstitialAd!.show();
//                                   } else {
//                                     debugPrint('InterstitialAd Not Loaded');
//                                     gameRef.audioComponent.stopBGM();
//                                     Navigator.of(context).pushAndRemoveUntil(
//                                         MaterialPageRoute(
//                                             builder: (context) => MainMenu()),
//                                         (Route<dynamic> route) => false);
//                                   }
//                                 },
//                                 child: Card(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     color: Colors.white70,
//                                     child: const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Main Menu",
//                                         style: TextStyle(
//                                             fontSize: 30, color: Colors.black),
//                                       ),
//                                     ))),
//                             TextButton(
//                                 onPressed: () {
//                                   isMenu = false;
//                                   if (interstitialAd != null) {
//                                     interstitialAd!.show();
//                                   } else {
//                                     debugPrint('InterstitialAd Not Loaded');
//                                     Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const MyGame()));
//                                   }
//                                 },
//                                 child: Card(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     color: Colors.white70,
//                                     child: const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Restart",
//                                         style: TextStyle(
//                                             fontSize: 30, color: Colors.black),
//                                       ),
//                                     ))),
//                           ],
//                         ),
//                         (rewardedAd != null)
//                             ? TextButton(
//                                 onPressed: () {
//                                   rewardedAd?.show(
//                                       onUserEarnedReward: (_, reward) {
//                                     gameRef.life.value =
//                                         reward.amount.toInt();
//                                   });
//                                 },
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   color: Colors.yellow,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Text(
//                                       'Watch 5 seconds ad to gain one more life'
//                                           .toUpperCase(),
//                                       style:
//                                           const TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : const SizedBox()
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//   }
// }
