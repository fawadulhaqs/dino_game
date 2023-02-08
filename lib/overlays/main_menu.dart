import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_first_game/overlays/menu.dart';
import 'package:my_first_game/overlays/players.dart';
import 'package:my_first_game/overlays/settings.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'game_view.dart';

// ignore: must_be_immutable
class MainMenu extends StatelessWidget {
  MainMenu({
    Key? key,
  }) : super(key: key);
  int? pageIndex = 1;
  var pages = [
    const Menu(),
    const Setting(),
    const Backgrounds(),
    const Players()
  ];

  @override
  Widget build(BuildContext context) {
    List<String> path = [
      'assets/images/bg/bgmain.png',
      'assets/images/bg/bgnight.png',
      'assets/images/bg/bgfuzzy.png',
      'assets/images/bg/bgmount.png',
      'assets/images/bg/bgwater.png'
    ];
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: const Text('Exit Dino'),
              content: const Text('Do you want to exit app?'),
              actions: [
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    MapProviders element = Provider.of<MapProviders>(context, listen: true);

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(path[element.mapIndex!]),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
                child: Consumer<TabProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.black.withOpacity(0.4),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'DINO RUN',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            color: Colors.white),
                                      ),
                                      OrientationBuilder(
                                        builder: (BuildContext context,
                                            Orientation orientation) {
                                          if (orientation ==
                                              Orientation.landscape) {
                                            return Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    width: 95,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/coin2.png',
                                                      width: 45,
                                                      height: 45,
                                                    ),
                                                    Text(
                                                      ' ${element.totalCoins}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          } else if(orientation == Orientation.portrait) {
                                            return const SizedBox();
                                          }
                                          return const SizedBox();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: pages[value.index!]),
                          ],
                        )),
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.black.withOpacity(0.4),
                            child: SizedBox(
                              width: 200,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyGame()));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          spreadRadius: 3,
                                                          blurRadius: 7,
                                                          offset: Offset(0, 0),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 15),
                                                    child: Text(
                                                      "Let's Play",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color: Colors.white),
                                                    ),
                                                  ))),
                                        ]),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            value.setIndex(0);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text('Home',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        const Divider(),
                                        TextButton(
                                          onPressed: () {
                                            value.setIndex(1);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text('Settings',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        const Divider(),
                                        TextButton(
                                          onPressed: () {
                                            value.setIndex(2);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text('Maps',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        const Divider(),
                                        TextButton(
                                          onPressed: () {
                                            value.setIndex(3);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text('Characters',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
