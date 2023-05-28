import 'dart:ui';
import 'dart:collection';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flappybird/player.dart';
import 'package:flappybird/background/horizon.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';

enum GameState { playing, intro, gameOver }

class FlappyBirdGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  late final player = Player();
  late final horizon = Horizon();
  late final TextComponent scoreText;

  int _score = 0;
  int _highscore = 0;
  int get score => _score;
  set score(int newScore) {
    _score = newScore;
    scoreText.text = '${scoreString(_score)}  HI ${scoreString(_highscore)}';
  }

  String scoreString(int score) => score.toString().padLeft(5, '0');

  ListQueue<Image> spriteImages = ListQueue();
  ListQueue<Image> tubeImages = ListQueue();
  GameState state = GameState.intro;
  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;
  double currentSpeed = 0.0;
  final double startSpeed = 600;
  late final SpriteComponent spriteComponent;

  /// Used for score calculation
  double _distanceTraveled = 0;

  @override
  bool debugMode = true;

  @override
  Color backgroundColor() => Color(0xff4bc4cf);

  @override
  Future<void> onLoad() async {
    spriteImages.add(await Flame.images.load('0.png'));
    spriteImages.add(await Flame.images.load('1.png'));
    spriteImages.add(await Flame.images.load('2.png'));
    spriteImages.add(await Flame.images.load('3.png'));

    tubeImages.add(await Flame.images.load('pipe.png'));
    tubeImages.add(await Flame.images.load('pipe_bottom.png'));
    tubeImages.add(await Flame.images.load('pipe_top.png'));

    add(player);
    add(horizon);

    const chars = '0123456789HI ';
    final renderer = SpriteFontRenderer.fromFont(
      SpriteFont(
        source: await Flame.images.load('num.png'),
        size: 23,
        ascent: 23,
        glyphs: [
          for (var i = 0; i < chars.length; i++)
            Glyph(chars[i], left: 0.0 + 20 * i, top: 0, width: 20)
        ],
      ),
      letterSpacing: 2,
    );
    add(scoreText = TextComponent(
      position: Vector2(20, size.y * 0.9),
      textRenderer: renderer,
    )
        //..positionType = PositionType.viewport,
        );
    score = 0;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      //jump
      if (isPlaying) {
        onAction();
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.enter)) {
      restart();
    }
    return KeyEventResult.handled;
  }

  void gameOver() {
    state = GameState.gameOver;
    player.current = PlayerState.crashed;
    currentSpeed = 0.0;
    horizon.reset();
  }

  void restart() {
    state = GameState.playing;
    player.reset();
    //horizon.reset();
    currentSpeed = startSpeed;
    //timePlaying = 0.0;
    if (score > _highscore) {
      _highscore = score;
    }
    score = 0;
    _distanceTraveled = 0;
  }

  void onAction() {
    player.jump(currentSpeed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlaying) {
      _distanceTraveled += dt * currentSpeed;
      score = _distanceTraveled ~/ 50;
      print('${score}');
    }
  }
}
