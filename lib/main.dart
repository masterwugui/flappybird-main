import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flappybird/FlappyBirdGame.dart';

void main() {
  runApp(
    GameWidget(game: FlappyBirdGame()),
  );
}
