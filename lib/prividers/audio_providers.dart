import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProviders extends ChangeNotifier {
  late bool _sfx;
  late bool _bgm;

  bool get sfx => _sfx;
  bool get bgm => _bgm;

  Future<void> turnSFX(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _sfx = value;
    notifyListeners();
    sp.setBool('SFX', value);
  }

  Future<void> turnBGM(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _bgm = value;
    notifyListeners();
    sp.setBool('BGM', value);
  }

  Future<void> getValues() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _sfx = sp.getBool('SFX') ?? true;
    _bgm = sp.getBool('BGM') ?? true;
  }

  Future<bool> getSFX() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isOn = sp.getBool('SFX') ?? true;
    return isOn;
  }
}

class MyAnimatedContainers extends ChangeNotifier {
  bool _isFirst = true;

  bool get isFirst => _isFirst;

  void setPage(bool value) {
    _isFirst = value;
    notifyListeners();
  }
}
