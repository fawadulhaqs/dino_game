import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends ChangeNotifier {
  int _highScore = 0;
  int _highCoin = 0;

  int get highScore => _highScore;
  int get highCoin => _highCoin;

  void setScore(int score) {
    _highScore = score;
    saveScore(score);
    notifyListeners();
  }

  void setCoin(int coin) {
    _highCoin = coin;
    saveCoin(coin);
    notifyListeners();
  }

  saveScore(int score) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('score', score);
  }

  saveCoin(int coin) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('coins', coin);
  }

  Future<void> getScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _highScore = sp.getInt('score') ?? 0;
    _highCoin = sp.getInt('coins') ?? 0;
  }
}
