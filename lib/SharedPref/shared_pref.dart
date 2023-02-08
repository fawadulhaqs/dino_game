import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  setHighest(int score, int coins) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if ((sp.getInt('score') ?? 0) < score) {
      sp.setInt('score', score);
    }
    if ((sp.getInt('coins') ?? 0) < coins) {
      sp.setInt('coins', coins);
    }
  }

  addCoins(int coins) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int addedCoins = coins + (sp.getInt('totalCoins') ?? 0);
    sp.setInt('totalCoins', addedCoins);
    print('Total Coins Collected ${sp.get('totalCoins')}');
  }
}
