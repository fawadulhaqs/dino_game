import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/dino.dart';
import 'package:my_first_game/Game/start_game.dart';

import '../Const/const.dart';


class Life extends SpriteAnimationComponent with HasGameRef<StartGame>,CollisionCallbacks{
  late SpriteAnimation _pigAnimation;
  final Random _fly = Random();
  late bool isHit;
  late Timer _timer;

  late int speed = 370;


  Life(): super();


  @override
  Future<void> onLoad()async {
    final dinoSprite = await gameRef.images.load('life.png');
    final dinoSheet = SpriteSheet(image: dinoSprite, srcSize: Vector2(64,64));
    isHit = false;
    _pigAnimation = dinoSheet.createAnimation(
      row: 0,
      stepTime: 0.08,
      from: 0,
      to: 1,
    );
    _timer = Timer(0.5 , repeat: false, onTick: (){
      isHit = false;
    });
    add(CircleHitbox(
      anchor: Anchor.center,
      radius: 20,
      position: Vector2(width/2,height/2)
    ));
    animation = _pigAnimation;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    height = width = (size.x / tilesPerWidth)+10;
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
      gameRef.life.value ++;
      gameRef.audioComponent.playSFX('heartbeat.wav',1.0);
      _timer.start();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Dino){
      if(gameRef.life.value <= 4){
        hit();
        removeFromParent();
      }
      removeFromParent();
    }
  }

}