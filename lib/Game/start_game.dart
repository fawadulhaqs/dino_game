import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:my_first_game/Game/fireball.dart';
import 'package:my_first_game/managers/audio_manager.dart';
import 'package:my_first_game/managers/enemy_manager.dart';
import '../Const/const.dart';
import '../main.dart';
import 'dino.dart';
import '../managers/gem_manager.dart';
import '../managers/life_manager.dart';

class StartGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Dino dino;
  final FireBall fireBall = FireBall();
  final SpriteAnimationComponent _gem = SpriteAnimationComponent();
  late ParallaxComponent _parallaxComponent;
  final Iterable<ParallaxData> _jungleParallaxComponent = [
    ParallaxImageData('BG1/bg1.png'),
    ParallaxImageData('BG1/bg2.png'),
    ParallaxImageData('BG1/bg3.png'),
    ParallaxImageData('BG1/bg4.png'),
    ParallaxImageData('rock2.png'),
  ];
  final Iterable<ParallaxData> _nightParallaxComponent = [
    ParallaxImageData('BG2/bg1.png'),
    ParallaxImageData('BG2/bg2.png'),
    ParallaxImageData('BG2/bg3.png'),
    ParallaxImageData('BG2/bg4.png'),
    ParallaxImageData('BG2/bg5.png'),
    ParallaxImageData('BG2/bg6.png'),
    ParallaxImageData('BG2/bg7.png'),
    ParallaxImageData('rock2.png'),
    ParallaxImageData('BG2/bg8.png'),
  ];
  final Iterable<ParallaxData> _mountainsParallaxComponent = [
    ParallaxImageData('BG4/bg1.png'),
    ParallaxImageData('BG4/bg2.png'),
    ParallaxImageData('BG4/bg3.png'),
    ParallaxImageData('BG4/bg4.png'),
    ParallaxImageData('BG4/bg5.png'),
    ParallaxImageData('BG4/bg6.png'),
    ParallaxImageData('BG4/bg7.png'),
    ParallaxImageData('BG4/bg8.png'),
    ParallaxImageData('rock2.png'),
    ParallaxImageData('BG4/bg9.png'),
  ];
  final Iterable<ParallaxData> _fuzzyParallaxComponent = [
    ParallaxImageData('BG3/bg1.png'),
    ParallaxImageData('BG3/bg2.png'),
    ParallaxImageData('BG3/bg3.png'),
    ParallaxImageData('BG3/bg4.png'),
    ParallaxImageData('BG3/bg5.png'),
    ParallaxImageData('BG3/bg6.png'),
    ParallaxImageData('BG3/bg7.png'),
    ParallaxImageData('rock2.png'),
  ];
  final Iterable<ParallaxData> _waterFallParallaxComponent = [
    ParallaxImageData('BG5/bg1.png'),
    ParallaxImageData('BG5/bg2.png'),
    ParallaxImageData('BG5/bg3.png'),
    ParallaxImageData('BG5/bg4.png'),
    ParallaxImageData('BG5/bg5.png'),
    ParallaxImageData('rock2.png'),
  ];
  late EnemyManager _enemyManager;
  late GemManager _gemManager;
  late LifeManager _lifeManager;
  late AudioComponent audioComponent;
  late SpriteAnimation _coinAnimation;
  double elapsedTime = 0.0;

  int adCounter = 1;

  late int score;
  late TextComponent scoreDisplay;
  late ValueNotifier<int> life;
  late ValueNotifier<int> gem;
  late TextComponent gemDisplay;
  late ValueNotifier<bool> isPaused = ValueNotifier(false);
  late bool isHit;

  @override
  Future<void> onLoad() async {
    final dinoSprite = await images.load('coin.png');
    final dinoSheet = SpriteSheet(image: dinoSprite, srcSize: Vector2(16, 16));

    audioComponent = AudioComponent();
    add(audioComponent);

    isHit = false;
    _coinAnimation = dinoSheet.createAnimation(
      row: 0,
      stepTime: 0.08,
      from: 0,
      to: 4,
    );
    isHit = false;
    isPaused = ValueNotifier(false);
    life = ValueNotifier(5);
    gem = ValueNotifier(0);
    if (sp?.getInt('bg') == 0) {
      _parallaxComponent = await ParallaxComponent.load(
          _jungleParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(100, 0),
          velocityMultiplierDelta: Vector2(1.3, 0));
    } else if (sp?.getInt('bg') == 1) {
      _parallaxComponent = await ParallaxComponent.load(_nightParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(45, 0),
          velocityMultiplierDelta: Vector2(1.3, 0));
    } else if (sp?.getInt('bg') == 2) {
      _parallaxComponent = await ParallaxComponent.load(_fuzzyParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(14.5, 0),
          velocityMultiplierDelta: Vector2(1.5, 0));
    } else if (sp?.getInt('bg') == 3) {
      _parallaxComponent = await ParallaxComponent.load(
          _mountainsParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(35, 0),
          velocityMultiplierDelta: Vector2(1.3, 0));
    } else if (sp?.getInt('bg') == 4) {
      _parallaxComponent = await ParallaxComponent.load(
          _waterFallParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(32, 0),
          velocityMultiplierDelta: Vector2(1.5, 0));
    } else {
      _parallaxComponent = await ParallaxComponent.load(
          _jungleParallaxComponent,
          alignment: Alignment.topCenter,
          baseVelocity: Vector2(100, 0),
          velocityMultiplierDelta: Vector2(1.3, 0));
    }
    add(_parallaxComponent);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    dino = Dino(playerType: getType()!);
    add(dino);

    add(fireBall);

    score = 0;
    scoreDisplay = TextComponent(text: score.toString())
      ..anchor = Anchor.topRight
      ..position = Vector2(size.x - 10, 10)
      ..textRenderer = TextPaint(
          style: const TextStyle(
              fontFamily: 'AudioWide',
              fontSize: 20,
              fontWeight: FontWeight.bold));
    add(scoreDisplay);

    _gemManager = GemManager();
    add(_gemManager);

    _lifeManager = LifeManager();
    add(_lifeManager);

    _gem.animation = _coinAnimation;
    add(_gem);

    gemDisplay = TextComponent(text: score.toString())
      ..anchor = Anchor.topLeft
      ..position = Vector2(_gem.x + _gem.width, size.y / 8)
      ..textRenderer = TextPaint(
          style: const TextStyle(
              fontFamily: 'AudioWide',
              fontSize: 20,
              fontWeight: FontWeight.bold));
    add(gemDisplay);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    _gem.height = _gem.width = (size.x / tilesPerWidth) - 40;
    _gem.y = size.y / 10;
  }

  @override
  void onAttach() {
    audioComponent.playBGM('bg_audio.mp3');
    super.onAttach();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);

    switch (state) {
      case AppLifecycleState.detached:
        isPaused.value = true;
        onPause();
        break;
      case AppLifecycleState.inactive:
        isPaused.value = true;
        onPause();
        break;
      case AppLifecycleState.paused:
        isPaused.value = true;
        onPause();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;
    if (elapsedTime > (1 / 90)) {
      elapsedTime = 0.0;
      score += 1;
      scoreDisplay.text = '${score.toString()}: Score';
    }
    gemDisplay.text = 'x ${gem.value.toString()}';
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    dino.jump();
  }

  void onPause() {
    pauseEngine();
    audioComponent.pauseBGM();
  }

  PlayerType? getType() {
    if (sp?.getInt('player') == 1) {
      return PlayerType.girl;
    } else if (sp?.getInt('player') == 2) {
      return PlayerType.men;
    } else if (sp?.getInt('player') == 3) {
      return PlayerType.magician;
    } else {
      return PlayerType.dino;
    } 
  }
}
