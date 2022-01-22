import 'dart:math';

import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'pixelart.dart';
import 'screenobject.dart';

final PixelArt background = PixelArt()
  ..imagePath = "assets/images/background.png"
  ..imageWidth = 1000
  ..imageHeight = 1700;

class Background extends ScreenObject {
  final Offset location;

  Background({this.location});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (location.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
        screenSize.height * -0.09,
        screenSize.width * 5,
        screenSize.height * 1.38);
  }

  @override
  Widget render() {
    return Image.asset(background.imagePath);
  }
}
