import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/dino.dart';
import 'package:my_first_game/Game/start_game.dart';

import '../Const/const.dart';


class Gems extends SpriteAnimationComponent with HasGameRef<StartGame>,CollisionCallbacks{
  late SpriteAnimation _pigAnimation;
  final Random _fly = Random();
  late bool isHit;
  late Timer _timer;

  late int speed = 370;


  Gems(): super();


  @override
  Future<void> onLoad()async {
    final dinoSprite = await gameRef.images.load('coin.png');
    final dinoSheet = SpriteSheet(image: dinoSprite, srcSize: Vector2(16,16));
    isHit = false;
    _pigAnimation = dinoSheet.createAnimation(
      row: 0,
      stepTime: 0.08,
      from: 0,
      to: 4,
    );
    _timer = Timer(0.5 , repeat: false, onTick: (){
      isHit = false;
    });
    add(CircleHitbox());
    animation = _pigAnimation;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    height = width = (size.x / tilesPerWidth)-30;
    x = width + gameRef.size.x;
    y = size.y - baseHeight - height-10;

    if(_fly.nextBool()){
      y = size.y - baseHeight - height - topBottomSpacing - 60;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed *dt;
    _timer.update(dt);
    if(x < (- width)){
      removeFromParent();
    }

  }

  void hit(){
    if(!isHit){
      isHit = true;
      gameRef.gem.value ++;
      gameRef.audioComponent.playSFX('Coin.wav',0.5);
      _timer.start();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Dino){
      hit();
      removeFromParent();
    }
  }

}