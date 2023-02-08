import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/enemies.dart';
import 'package:my_first_game/Game/fireball.dart';
import 'package:my_first_game/Game/start_game.dart';

import '../Const/const.dart';

enum PlayerType { dino, men, girl, magician }

class PlayerData {
  final String imagePath;
  final int jumpFrom;
  final int jumpTo;
  final int hitFrom;
  final int hitTo;
  final int runFrom;
  final int runTo;
  final double jumpStepTime;
  final double hitStepTime;
  final double runStepTime;
  final Vector2 srcSize;
  final int extraSize;

  PlayerData(
      {required this.imagePath,
      required this.jumpFrom,
      required this.jumpTo,
      required this.hitFrom,
      required this.hitTo,
      required this.runFrom,
      required this.runTo,
      required this.jumpStepTime,
      required this.hitStepTime,
      required this.runStepTime,
      required this.srcSize,
      required this.extraSize});
}

class Dino extends SpriteAnimationComponent
    with HasGameRef<StartGame>, CollisionCallbacks {
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;
  late SpriteAnimation _jumpAnimation;
  double speedY = 0.0;
  double yMax = 0.0;

  final Map<PlayerType, PlayerData> playerDetails = {
    PlayerType.dino: PlayerData(
        imagePath: 'Dino.png',
        jumpFrom: 0,
        jumpTo: 3,
        hitFrom: 14,
        hitTo: 16,
        runFrom: 4,
        runTo: 10,
        jumpStepTime: 0.2,
        hitStepTime: 0.07,
        runStepTime: 0.07,
        srcSize: Vector2(24, 24),
        extraSize: 30),
    PlayerType.men: PlayerData(
        imagePath: 'men.png',
        jumpFrom: 13,
        jumpTo: 14,
        hitFrom: 0,
        hitTo: 2,
        runFrom: 3,
        runTo: 11,
        jumpStepTime: 0.3,
        hitStepTime: 0.07,
        runStepTime: 0.07,
        srcSize: Vector2(256, 256),
        extraSize: 140),
    PlayerType.girl: PlayerData(
        imagePath: 'women.png',
        jumpFrom: 14,
        jumpTo: 15,
        hitFrom: 0,
        hitTo: 2,
        runFrom: 3,
        runTo: 11,
        jumpStepTime: 0.3,
        hitStepTime: 0.07,
        runStepTime: 0.07,
        srcSize: Vector2(256, 256),
        extraSize: 140),
    PlayerType.magician: PlayerData(
        imagePath: 'magician.png',
        jumpFrom: 14,
        jumpTo: 15,
        hitFrom: 0,
        hitTo: 2,
        runFrom: 3,
        runTo: 11,
        jumpStepTime: 0.3,
        hitStepTime: 0.07,
        runStepTime: 0.07,
        srcSize: Vector2(256, 256),
        extraSize: 140),
  };

  PlayerType playerType;
  Dino({required this.playerType}) : super();
  late Timer hitTimer;
  late Timer jumpTimer;

  @override
  Future<void> onLoad() async {
    final player = playerDetails[playerType];
    final dinoSprite = await gameRef.images.load(player!.imagePath); //here
    final dinoSheet =
        SpriteSheet(image: dinoSprite, srcSize: player.srcSize); //here

    _runAnimation = dinoSheet.createAnimation(
        row: 0,
        stepTime: player.runStepTime,
        to: player.runTo,
        from: player.runFrom); //here
    _hitAnimation = dinoSheet.createAnimation(
        row: 0,
        stepTime: player.hitStepTime,
        to: player.hitTo,
        from: player.hitFrom);
    _jumpAnimation = dinoSheet.createAnimation(
        row: 0,
        stepTime: player.jumpStepTime,
        to: player.jumpTo,
        from: player.jumpFrom);
    hitTimer = Timer(1, repeat: false, onTick: () {
      gameRef.isHit = false;
      run();
    });
    if (playerType != PlayerType.dino) {
      add(RectangleHitbox(
          anchor: Anchor.center,
          size: Vector2(50, 95),
          position:
              Vector2(width - width / 1.7, size.y - topBottomSpacing + 20)));
    } else {
      add(RectangleHitbox(
          anchor: Anchor.center,
          size: Vector2(70, 40),
          position: Vector2(width - width / 2, size.y - topBottomSpacing - 5)));
      add(RectangleHitbox(
          anchor: Anchor.center,
          size: Vector2(40, 70),
          position:
              Vector2(width - width / 2, size.y - topBottomSpacing + 15)));
    }
    animation = _runAnimation;
    // debugMode = true;
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final player = playerDetails[playerType];
    height = width = (size.x / tilesPerWidth) + player!.extraSize; //here
    x = width;
    y = size.y - baseHeight - height + topBottomSpacing; //here
    if (playerType != PlayerType.dino) {
      y = size.y - 5 - height + topBottomSpacing;
      x = width - width / 3;
    } //here
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
