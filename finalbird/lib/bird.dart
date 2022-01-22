import 'package:finalbird/constants.dart';
import 'package:flutter/material.dart';

import 'pixelart.dart';
import 'screenobject.dart';

List<PixelArt> bird = [
  PixelArt()
    ..imagePath = "assets/images/kuspoz1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  PixelArt()
    ..imagePath = "assets/images/kuspoz2.png"
    ..imageWidth = 88
    ..imageHeight = 94
];

enum BirdState { flying, flyingUp, dead }
enum BirdPlace { wentUp, wentDown }

class Bird extends ScreenObject {
  PixelArt currentArt = bird[0];
  double displayMove = 0;
  double velocity = 0;
  double displayPlace = 0;

  BirdState birdState = BirdState.flying;
  BirdPlace birdPlace = BirdPlace.wentDown;
  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        screenSize.width / 7,
        screenSize.height / 2 -
            displayMove +
            currentArt.imageHeight * 1.3 +
            displayPlace,
        currentArt.imageWidth.toDouble(),
        currentArt.imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(currentArt.imagePath);
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    currentArt = bird[(elapsedTime.inMilliseconds / 100).floor() % 2];
    double elapsedTimeInSeconds =
        (elapsedTime - lastUpdate).inMilliseconds / 1000;
    displayMove += velocity * elapsedTimeInSeconds;
    if (displayMove <= 0) {
      displayMove = 0;
      velocity = 0;
      birdState = BirdState.flying;
    } else {
      velocity -= GRAVITY_PPSS * elapsedTimeInSeconds;
    }
  }

  void flyUp() {
    if (birdState != BirdState.flyingUp) {
      birdState = BirdState.flyingUp;
      velocity = 700;
    }
  }

  void goUp() {
    if (birdPlace != BirdPlace.wentUp) {
      birdPlace = BirdPlace.wentUp;
      displayPlace = -currentArt.imageHeight * (3).toDouble();
    }
  }

  void goDown() {
    if (birdPlace != BirdPlace.wentDown) {
      birdPlace = BirdPlace.wentDown;
      displayPlace = 0;
    }
  }

  void die() {
    currentArt = bird[0];
    birdState = BirdState.dead;
  }
}
