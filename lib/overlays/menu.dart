import 'package:flutter/material.dart';
import 'package:my_first_game/main.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'DINO RUN',
                style: TextStyle(fontSize: 60, color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const MyGame()));
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white70,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Let's Play",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ))),
              Consumer<MyAnimatedContainers>(
                builder: (BuildContext context, value, Widget? child) {
                  return TextButton(
                      onPressed: () {
                        value.setPage(false);
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white70,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Settings",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
