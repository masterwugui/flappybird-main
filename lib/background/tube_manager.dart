import 'package:flame/components.dart';
import 'package:flappybird/background/Tube.dart';
import 'package:flappybird/random_extension.dart';
import 'package:flappybird/FlappyBirdGame.dart';

class TubeManager extends PositionComponent with HasGameRef<FlappyBirdGame> {
  final double tubeFrequency = 0.5;
  final int maxTubes = 20;
  final double bgTubeSpeed = 0.2;

  void addTube() {
    final tubePosition = Vector2(
      gameRef.size.x + Tube.initialSize.x + 10,
      absolutePosition.y,
    );
    add(Tube(position: tubePosition));
  }

  double get TubeSpeed => bgTubeSpeed / 1000 * gameRef.currentSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    final numTubes = children.length;
    if (numTubes > 0) {
      final lastTube = children.last as Tube;
      if (numTubes < maxTubes &&
          (gameRef.size.x - lastTube.x) > lastTube.tubeGap) {
        addTube();
      }
    } else {
      addTube();
    }
  }

  void reset() {
    removeAll(children);
  }
}
