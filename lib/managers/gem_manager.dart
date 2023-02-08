import 'dart:async';
import 'package:flame/components.dart';
import 'package:my_first_game/Game/gems.dart';
import 'package:my_first_game/Game/start_game.dart';

class GemManager extends Component with HasGameRef<StartGame>{


  late Timer _timer1;


  @override
  Future<void> onLoad()async{
    _timer1 = Timer(0.7,repeat: true ,onTick: (){
      spawnGem();
    });

    return super.onLoad();
  }

  spawnGem(){
    final newGem = Gems();
    gameRef.add(newGem);
  }

  @override
  void onMount() {
    super.onMount();
    _timer1.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer1.update(dt);
  }
}