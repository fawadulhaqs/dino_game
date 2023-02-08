import 'package:flutter/material.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';

import '../main.dart';

enum SelectedBG { jungle, night, fuzzyMountains, mountains, waterFall }

class Backgrounds extends StatelessWidget {
  const Backgrounds({super.key});

  SelectedBG? getGroup() {
    if (sp?.getInt('bg') == 0) {
      return SelectedBG.jungle;
    } else if (sp?.getInt('bg') == 1) {
      return SelectedBG.night;
    } else if (sp?.getInt('bg') == 2) {
      return SelectedBG.fuzzyMountains;
    } else if (sp?.getInt('bg') == 3) {
      return SelectedBG.mountains;
    } else if (sp?.getInt('bg') == 4) {
      return SelectedBG.waterFall;
    } else {
      return SelectedBG.jungle;
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((sp?.getStringList('inventory')) == []) {
      sp?.setStringList('inventory', ['JUNGLE']);
    }
    Future<bool> showPricePopUp() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color.fromARGB(255, 51, 51, 51),
              title: const Text(
                'Insufficient Coins!!!',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text('You do not have enogh coins to buy this Map',
                  style: TextStyle(color: Colors.white)),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 63, 189, 67),
                              Color.fromARGB(255, 56, 161, 60)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.5],
                          )),
                      child: const Center(
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    Future<bool> showBuyPopUp(value, String mapName, int price) async {
      MapProviders element = Provider.of<MapProviders>(context, listen: false);
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color.fromARGB(255, 51, 51, 51),
              title: Text(mapName, style: const TextStyle(color: Colors.white)),
              content: Text(
                  'Are Sure you want to buy this map for $price coins?',
                  style: const TextStyle(color: Colors.white)),
              actions: [
                GestureDetector(
                  onTap: () {
                    int coins = sp?.getInt('totalCoins') ?? 0;
                    value.setInventory(mapName);
                    Navigator.of(context).pop(false);
                    int remainingCoins = coins - price;
                    sp?.setInt('totalCoins', remainingCoins);
                    element.setCoins(remainingCoins);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 63, 189, 67),
                              Color.fromARGB(255, 56, 161, 60)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.5],
                          )),
                      child: const Center(
                        child: Text(
                          'BUY',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    List<String> path = [
      'assets/images/bg/bgmain.png',
      'assets/images/bg/bgnight.png',
      'assets/images/bg/bgfuzzy.png',
      'assets/images/bg/bgmount.png',
      'assets/images/bg/bgwater.png'
    ];
    List<String> name = ['JUNGLE', 'DIMMET', 'FUZZY', 'MOUNTAINS', 'WATERFALL'];
    List<int> price = [0, 290, 500, 900, 1500];
    return Center(
      child: Card(
        color: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'MAPS'.toUpperCase(),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.white),
                  ),
                ),
                const Divider(
                  endIndent: 200,
                ),
                Row(
                  children: [
                    Expanded(child: Consumer<MapProviders>(
                      builder: (BuildContext context, value, Widget? child) {
                        return SizedBox(
                          height: 190,
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final inventory = value.inventory;
                              final mapName = name[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (inventory.contains(mapName)) {
                                          sp?.setInt('bg', index);
                                          value.clearMap();
                                          value.setMap(name[index]);
                                        } else {
                                          if ((sp?.getInt('totalCoins') ?? 0) >=
                                              price[index]) {
                                            showBuyPopUp(
                                                value, mapName, price[index]);
                                            // value.setInventory(mapName);
                                            // print('added');
                                            // print(inventory);
                                          } else {
                                            showPricePopUp();
                                          }
                                        }
                                      },
                                      onLongPress: () {
                                        value.clearInventory();
                                      },
                                      child: Container(
                                        height: 165,
                                        width: 260,
                                        decoration: (value.selectedMap!
                                                .contains(mapName))
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 4))
                                            : null,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          fit: StackFit.expand,
                                          children: [
                                            Image.asset(
                                              path[index],
                                              fit: BoxFit.cover,
                                            ),
                                            (!inventory.contains(mapName))
                                                ? Container(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                  )
                                                : const SizedBox(),
                                            (!inventory.contains(mapName))
                                                ? const Icon(
                                                    Icons.lock,
                                                    size: 30,
                                                    color: Colors.white,
                                                  )
                                                : const SizedBox(),
                                            (!inventory.contains(mapName))
                                                ? Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(
                                                              255, 63, 189, 67),
                                                          Color.fromARGB(
                                                              255, 56, 161, 60)
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        stops: [0.5, 0.5],
                                                      )),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            ' ${price[index]}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          Image.asset(
                                                            'assets/images/coin2.png',
                                                            width: 30,
                                                            height: 30,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            (value.selectedMap!
                                                    .contains(mapName))
                                                ? const Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Icon(
                                                      Icons.done_outline,
                                                      color: Colors.yellow,
                                                      size: 30,
                                                    ))
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(name[index],
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.white))
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
