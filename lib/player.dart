import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappybird/FlappyBirdGame.dart';

enum PlayerState { flying, waiting, jumping, crashed }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Player() : super(size: Vector2(39, 33));

  final double gravity = 1;

  final double initialJumpVelocity = -15.0;
  final double introDuration = 1500.0;
  late double startXPosition = gameRef.size.x / 3;
  late double lastJumpY = 0.0;
  double _jumpVelocity = 0.0;

  double get groundYPos {
    return (gameRef.size.y / 2) - height / 2;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());

    animations = {
      PlayerState.flying: _getAnimation(
        indexs: [0, 1, 2],
        stepTime: 0.2,
      ),
      PlayerState.waiting: _getAnimation(
        indexs: [0],
      ),
      PlayerState.jumping: _getAnimation(
        indexs: [3, 0],
      ),
    };
    current = PlayerState.waiting;
  }

  void jump(double speed) {
    current = PlayerState.jumping;
    _jumpVelocity = initialJumpVelocity;
    lastJumpY = y;
  }

  void reset() {
    y = groundYPos;
    _jumpVelocity = 0.0;
    current = PlayerState.flying;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > lastJumpY) {
        y = lastJumpY;
        _jumpVelocity = 0.0;
        current = PlayerState.flying;
      }
      if (y < 0) {
        y = 0;
      }
    } else if (current == PlayerState.flying) {
      y += gravity;
    } else {
      y = groundYPos;
    }

    if (gameRef.isIntro && x < startXPosition) {
      x += (startXPosition / introDuration) * dt * 5000;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameRef.gameOver();
  }

  SpriteAnimation _getAnimation({
    required List<int> indexs,
    double stepTime = double.infinity,
  }) {
    return SpriteAnimation.spriteList(
      indexs
          .map(
            (index) => Sprite(
              gameRef.spriteImages.elementAt(index),
              srcSize: size,
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
