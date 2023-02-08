import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:my_first_game/Game/start_game.dart';

class FireBall extends SpriteAnimationComponent
    with HasGameRef<StartGame>, CollisionCallbacks {
  late SpriteAnimation _fireAnimation;
  double fireSpeed = 700.0;
  FireBall() : super();

  @override
  Future<void> onLoad() async {
    final fireSprite = await gameRef.images.load('fireball.png');
    final fireSheet = SpriteSheet(image: fireSprite, srcSize: Vector2(64, 32));

    _fireAnimation =
        fireSheet.createAnimation(row: 0, stepTime: 0.04, to: 3, from: 0);
    add(CircleHitbox());
    animation = _fireAnimation;
    // debugMode = true;
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    width = 64;
    height = 32;
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= fireSpeed * dt;
  }
}
