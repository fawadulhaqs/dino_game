import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> sfx = ValueNotifier(sp?.getBool('SFX') ?? true);
    ValueNotifier<bool> bgm = ValueNotifier(sp?.getBool('BGM') ?? true);
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white),
                ),
              ),
              const Divider(
                endIndent: 200,
              ),
              ValueListenableBuilder(
                valueListenable: sfx,
                builder: (BuildContext context, value, Widget? child) {
                  return SizedBox(
                    // width: 400,
                    child: SwitchListTile(
                        subtitle: const Text('Jump, Hit & other sounds',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white70)),
                        title: const Text('SFX',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        value: value,
                        onChanged: (changedValue) async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sfx.value = changedValue;
                          sp.setBool('SFX', changedValue);
                        }),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: bgm,
                builder: (BuildContext context, value, Widget? child) {
                  return SizedBox(
                    child: SwitchListTile(
                        subtitle: const Text(
                          'Background Music',
                          style: TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                        value: value,
                        title: const Text(
                          'BGM',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onChanged: (changedValue) async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          bgm.value = changedValue;
                          sp.setBool('BGM', changedValue);
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
