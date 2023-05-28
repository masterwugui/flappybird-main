import 'dart:collection';
import 'package:flame/components.dart';
import 'package:flappybird/background/tube_manager.dart';
import 'package:flappybird/background/smalltube.dart';
import 'package:flappybird/random_extension.dart';
import 'package:flappybird/FlappyBirdGame.dart';

class Tube extends PositionComponent
    with ParentIsA<TubeManager>, HasGameRef<FlappyBirdGame> {
  Tube({required Vector2 position})
      : tubeGap = random.fromRange(
          minTubeGap,
          maxTubeGap,
        ),
        super(position: position);
  static Vector2 initialSize = Vector2(40.0, 20.0);
  static const double maxTubeGap = 40.0;
  static const double minTubeGap = 0.0;
  final double leftPadding = 2.0;
  final double tubeGap;

  @override
  Future<void> onLoad() async {
    //先建造上面的水管
    double tempY = 0;
    Vector2 smallTubePosition = Vector2(leftPadding, tempY);
    int tubeNums = random
        .fromRange(
          10,
          30,
        )
        .toInt();
    for (int i = 0; i < tubeNums; i++) {
      add(smallTube(position: smallTubePosition, type: 0));
      tempY += 20.0;
      smallTubePosition = Vector2(leftPadding, tempY);
    }
    add(smallTube(position: Vector2(0, tempY), type: 2));

    //空出一段让小鸟过去
    tempY += random.fromRange(
      198,
      396,
    );

    //再建造下面的水管
    double remainY = gameRef.size.y * 0.8 + 100 - tempY;
    int remainNum = (remainY / 20.0).floor();
    if (remainNum < 2) {
      return;
    }
    tempY += remainY - remainNum * 20.0;
    smallTubePosition = Vector2(0, tempY);
    add(smallTube(position: smallTubePosition, type: 1));
    for (int i = 0; i < remainNum - 1; i++) {
      tempY += 20.0;
      smallTubePosition = Vector2(leftPadding, tempY);
      add(smallTube(position: smallTubePosition, type: 0));
    }
  }

  final double bgCloudSpeed = 0.2;
  double get tubeSpeed => bgCloudSpeed / 1000 * gameRef.currentSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    x -= tubeSpeed.ceil() * 50 * dt;
    if (x <= 0) {
      removeFromParent();
    }
  }
}
