import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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

class TabProvider extends ChangeNotifier {
  int? _index = 0;
  int? get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}

List<String> name = ['JUNGLE', 'DIMMET', 'FUZZY', 'MOUNTAINS', 'WATERFALL'];

class MapProviders extends ChangeNotifier {
  int? _totalCoins = sp?.getInt('totalCoins');

  int? get totalCoins => _totalCoins;

  void setCoins(int coins) {
    _totalCoins = coins;
    notifyListeners();
  }

  List<String> _inventory = sp?.getStringList('inventory') ?? ['JUNGLE'];

  List<String> get inventory => _inventory;

  final List? _selectedMap = [name[sp?.getInt('bg') ?? 0]];

  int? _mapIndex = sp?.getInt('bg') ?? 0;

  int? get mapIndex => _mapIndex;

  List? get selectedMap => _selectedMap;

  void setMap(String? newName) {
    _selectedMap?.add(newName);
    _mapIndex = name.indexOf(newName!);
    notifyListeners();
  }

  void setInventory(String name) {
    _inventory.add(name);
    sp?.setStringList('inventory', inventory);
    notifyListeners();
  }

  void clearInventory() {
    sp?.setStringList('inventory', ['JUNGLE', 'DINO']);
    _inventory = sp?.getStringList('inventory') ?? ['JUNGLE', 'DINO'];
    notifyListeners();
  }

  void clearMap() {
    _selectedMap?.clear();
  }
}

List<String> playerName = ['DINO', 'WOMEN', 'MAN', 'MAGICIAN'];

class PlayerProviders extends ChangeNotifier {
  List<String> _inventory =
      sp?.getStringList('inventory') ?? ['JUNGLE', 'DINO'];

  List<String> get inventory => _inventory;

  final List? _selectedPlayer = [playerName[sp?.getInt('player') ?? 0]];

  List? get selectedPlayer => _selectedPlayer;

  void setPlayer(String? newName) {
    _selectedPlayer?.add(newName);
    notifyListeners();
  }

  void setInventory(String name) {
    _inventory.add(name);
    sp?.setStringList('inventory', inventory);
    notifyListeners();
  }

  void clearInventory() {
    sp?.setStringList('inventory', ['JUNGLE', 'DINO']);
    _inventory = sp?.getStringList('inventory') ?? ['JUNGLE', 'DINO'];
    notifyListeners();
  }

  void clearMap() {
    _selectedPlayer?.clear();
  }
}
