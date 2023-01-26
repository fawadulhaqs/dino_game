import 'package:flame/components.dart';
import 'package:my_first_game/Game/health.dart';
import 'package:my_first_game/Game/start_game.dart';

class LifeManager extends Component with HasGameRef<StartGame>{


  late Timer _timer;

  @override
  Future<void> onLoad()async{

    _timer = Timer(20,repeat: true ,onTick: (){
      spawnLife();
    });

    return super.onLoad();
  }

  spawnLife(){
    final newLife = Life();
    gameRef.add(newLife);
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
  }
}