import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/enemies.dart';
import 'package:my_first_game/Game/fireball.dart';
import 'package:my_first_game/Game/start_game.dart';

import '../Const/const.dart';

class Dino extends SpriteAnimationComponent
    with HasGameRef<StartGame>, CollisionCallbacks {
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;
  late SpriteAnimation _jumpAnimation;
  double speedY = 0.0;
  double yMax = 0.0;
  Dino() : super();
  late Timer hitTimer;
  late Timer jumpTimer;

  @override
  Future<void> onLoad() async {
    final dinoSprite = await gameRef.images.load('Dino.png');
    final dinoSheet = SpriteSheet(image: dinoSprite, srcSize: Vector2(24, 24));

    _runAnimation =
        dinoSheet.createAnimation(row: 0, stepTime: 0.06, to: 10, from: 4);
    _hitAnimation =
        dinoSheet.createAnimation(row: 0, stepTime: 0.07, to: 16, from: 14);
    _jumpAnimation =
        dinoSheet.createAnimation(row: 0, stepTime: 0.2, to: 3, from: 0);
    hitTimer = Timer(1, repeat: false, onTick: () {
      gameRef.isHit = false;
      run();
    });
    add(RectangleHitbox(
        anchor: Anchor.center,
        size: Vector2(70, 40),
        position: Vector2(width - width / 2, size.y - topBottomSpacing - 5)));
    add(RectangleHitbox(
        anchor: Anchor.center,
        size: Vector2(40, 70),
        position: Vector2(width - width / 2, size.y - topBottomSpacing + 15)));
    animation = _runAnimation;
    // debugMode = true;
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    height = width = (size.x / tilesPerWidth) + 30;
    x = width;
    y = size.y - baseHeight - height + topBottomSpacing;
    yMax = y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    speedY += gravity * dt;
    y += speedY * dt;

    if (isOnGround()) {
      y = yMax;
      speedY = 0.0;
      if (!gameRef.isHit) {
        animation = _runAnimation;
      }
    }
    hitTimer.update(dt);
  }

  void run() {
    gameRef.isHit = false;
    animation = _runAnimation;
  }

  void hit() {
    if (!gameRef.isHit) {
      animation = _hitAnimation;
      hitTimer.start();
      gameRef.isHit = true;
      gameRef.life.value--;
      gameRef.audioComponent.playSFX('hurt.wav', 1.0);
    }
  }

  bool isOnGround() {
    return (y >= yMax);
  }

  void jump() {
    if (!gameRef.isHit) {
      animation = _jumpAnimation;
    }
    if (isOnGround()) {
      speedY = -850;
      if (!gameRef.paused) {
        gameRef.audioComponent.playSFX('Jump.wav', 1.0);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemies) {
      hit();
    }
    if (other is FireBall) {
      hit();
    }
  }
}
