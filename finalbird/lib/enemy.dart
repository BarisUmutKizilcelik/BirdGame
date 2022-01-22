import 'dart:math';

import 'package:finalbird/constants.dart';
import 'package:finalbird/pixelart.dart';
import 'package:finalbird/screenobject.dart';
import 'package:flutter/widgets.dart';

List<PixelArt> ENEMIES = [
  PixelArt()
    ..imagePath = "assets/images/plane.png"
    ..imageWidth = 104
    ..imageHeight = 100,
  PixelArt()
    ..imagePath = "assets/images/eagle.png"
    ..imageWidth = 104
    ..imageHeight = 100
];

class Enemy extends ScreenObject {
  final PixelArt enemy;
  final Offset location;

  Enemy({this.location}) : enemy = ENEMIES[Random().nextInt(ENEMIES.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (location.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
        screenSize.height / 2 + enemy.imageHeight,
        enemy.imageWidth.toDouble(),
        enemy.imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(enemy.imagePath);
  }
}
