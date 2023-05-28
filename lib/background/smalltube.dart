import 'package:flame/components.dart';
import 'package:flappybird/background/tube.dart';
import 'package:flappybird/FlappyBirdGame.dart';
import 'package:flutter/painting.dart';

class smallTube extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  smallTube({required Vector2 position, required int this.type})
      : super(position: position);
  static Vector2 initialSize = Vector2(40.0, 20.0);
  late final int type;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.tubeImages.elementAt(type));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
