import 'dart:math';

import 'package:flame/components.dart';
import 'package:my_first_game/Game/enemies.dart';
import 'package:my_first_game/Game/start_game.dart';

class EnemyManager extends Component with HasGameRef<StartGame> {
  late Random _random;
  late Timer _timer;
  late int spawnLevel;

  @override
  Future<void> onLoad() async {
    spawnLevel = 0;
    _random = Random();
    _timer = Timer(3, repeat: true, onTick: () {
      spawnRandom();
    });

    return super.onLoad();
  }

  spawnRandom() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemy = EnemyType.values.elementAt(randomNumber);
    final newEnemy = Enemies(enemyType: randomEnemy);
    gameRef.add(newEnemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    var newSpawnLevel = gameRef.score ~/ 500;
    if (spawnLevel < newSpawnLevel) {
      spawnLevel = newSpawnLevel;

      var newWaitTime = (3 / (1 + (newSpawnLevel * 0.1)));

      _timer.stop();

      _timer = Timer(newWaitTime, repeat: true, onTick: () {
        spawnRandom();
      });
      _timer.start();
    }
  }
}
