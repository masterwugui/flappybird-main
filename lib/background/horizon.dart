import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flappybird/FlappyBirdGame.dart';
import 'package:flappybird/background/tube_manager.dart';

class Horizon extends PositionComponent with HasGameRef<FlappyBirdGame> {
  Horizon() : super();
  late final TubeManager tubeManager = TubeManager();

  @override
  Future<void> onLoad() async {
    add(tubeManager);

    //增加地面
    add(await gameRef.loadParallaxComponent(
        [ParallaxImageData("background.png")],
        size: Vector2(gameRef.size.x, 166),
        position: Vector2(0, gameRef.size.y * 0.8)));
    //增加地面的碰撞体积
    add(RectangleHitbox(
        size: Vector2(gameRef.size.x, gameRef.size.y * 0.2),
        position: Vector2(0, gameRef.size.y * 0.8)));
  }

  void reset() {
    tubeManager.reset();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }
}
