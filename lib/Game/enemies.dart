import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/start_game.dart';
import '../Const/const.dart';

enum EnemyType { pig, rino, bat, pot }

class EnemyData {
  final String imagePath;
  final int from;
  final int to;
  final int eWidth;
  final int eHeight;
  final double stepTime;
  final int speed;
  final Vector2 srcSize;
  final bool canFly;
  final bool isPot;

  EnemyData(
      {required this.imagePath,
      required this.from,
      required this.to,
      required this.eWidth,
      required this.eHeight,
      required this.stepTime,
      required this.speed,
      required this.srcSize,
      required this.canFly,
      required this.isPot});
}

class Enemies extends SpriteAnimationComponent
    with HasGameRef<StartGame>, CollisionCallbacks {
  late SpriteAnimation _enemyAnimation;
  late int textureWidth = 0;
  late int textureHeight;
  final Random _fly = Random();
  bool potSpawn = false;

  late int speed = 0;
  final Map<EnemyType, EnemyData> enemyDetails = {
    EnemyType.pig: EnemyData(
        imagePath: 'enemy1(36x30).png',
        from: 0,
        to: 15,
        eWidth: 36,
        eHeight: 30,
        stepTime: 0.04,
        speed: 470,
        srcSize: Vector2(36, 30),
        canFly: false,
        isPot: false),
    EnemyType.rino: EnemyData(
        imagePath: 'rino(52x34).png',
        from: 0,
        to: 5,
        eWidth: 52,
        eHeight: 34,
        stepTime: 0.03,
        speed: 600,
        srcSize: Vector2(52, 34),
        canFly: false,
        isPot: false),
    EnemyType.bat: EnemyData(
        imagePath: 'bat(46x30).png',
        from: 0,
        to: 6,
        eWidth: 46,
        eHeight: 30,
        stepTime: 0.05,
        speed: 450,
        srcSize: Vector2(46, 30),
        canFly: true,
        isPot: false),
    EnemyType.pot: EnemyData(
        imagePath: 'pot(44x42).png',
        from: 0,
        to: 10,
        eWidth: 44,
        eHeight: 42,
        stepTime: 0.09,
        speed: 370,
        srcSize: Vector2(44, 42),
        canFly: false,
        isPot: true),
  };

  EnemyType enemyType;
  Enemies({required this.enemyType}) : super();

  @override
  Future<void> onLoad() async {
    final enemy = enemyDetails[enemyType];
    textureWidth = enemy!.eWidth;
    textureHeight = enemy.eHeight;
    final dinoSprite = await gameRef.images.load(enemy.imagePath);
    final dinoSheet = SpriteSheet(image: dinoSprite, srcSize: enemy.srcSize);

    _enemyAnimation = dinoSheet.createAnimation(
      row: 0,
      stepTime: enemy.stepTime,
      from: enemy.from,
      to: enemy.to,
    );
    if (enemy.isPot) {
      potSpawn = true;
    }
    speed = enemy.speed;
    if (enemyType == EnemyType.pot) {
      add(RectangleHitbox(
          size: Vector2(50, 65),
          anchor: Anchor.center,
          position: Vector2(width - width / 2.5,
              size.y - topBottomSpacing + baseHeight / 1.2)));
    } else {
      add(CircleHitbox(
          radius: height / 2,
          anchor: Anchor.center,
          position: Vector2(width - width / 2,
              size.y - topBottomSpacing + baseHeight / 1.2)));
    }
    animation = _enemyAnimation;
    debugMode = true;
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final enemy = enemyDetails[enemyType];
    double scale = (size.x / tilesPerWidth) / enemy!.eWidth;
    // fireBall.width = 64;
    // fireBall.height = 32;
    height = enemy.eHeight * scale + 10;
    width = enemy.eWidth * scale + 10;
    x = width + gameRef.size.x;
    y = gameRef.size.y - baseHeight - (height / 2);

    if (enemy.canFly && _fly.nextBool()) {
      y = size.y - baseHeight - enemy.eHeight - topBottomSpacing - 60;
    }

    if (enemy.isPot == true) {
      potSpawn = true;
      gameRef.fireBall.x = gameRef.fireBall.width + gameRef.size.x;
      gameRef.fireBall.y = gameRef.size.y - baseHeight - (height / 2);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
    if (x < (-width)) {
      removeFromParent();
    }
  }
}
