import 'package:flutter/material.dart';
import 'package:my_first_game/prividers/audio_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> sfx = ValueNotifier(true);
    ValueNotifier<bool> bgm = ValueNotifier(true);

    Future<void> getValues() async {
      SharedPreferences sp = await SharedPreferences.getInstance();

      sfx.value = sp.getBool('SFX') ?? true;
      bgm.value = sp.getBool('BGM') ?? true;
    }

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50),
          child: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                    future: getValues(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'SETTINGS',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                          ValueListenableBuilder(
                            valueListenable: sfx,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return SwitchListTile(
                                  value: value,
                                  title: const Text('SFX',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  onChanged: (changedValue) async {
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    sfx.value = changedValue;
                                    sp.setBool('SFX', changedValue);
                                  });
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: bgm,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return SwitchListTile(
                                  value: value,
                                  title: const Text(
                                    'BGM',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  onChanged: (changedValue) async {
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    bgm.value = changedValue;
                                    sp.setBool('BGM', changedValue);
                                  });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Consumer<MyAnimatedContainers>(
                    builder: (BuildContext context, value, Widget? child) {
                      return IconButton(
                          onPressed: () {
                            value.setPage(true);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.white,
                            size: 30,
                          ));
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
