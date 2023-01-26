import 'package:flame/components.dart';
import 'package:my_first_game/Game/start_game.dart';
import '../Game/fireball.dart';

class FireBallManager extends Component with HasGameRef<StartGame>{

  @override
  Future<void> onLoad()async{

      spawnFireBall();

    return super.onLoad();
  }

  spawnFireBall(){
    final newFireBall = FireBall();
    gameRef.add(newFireBall);
  }
}