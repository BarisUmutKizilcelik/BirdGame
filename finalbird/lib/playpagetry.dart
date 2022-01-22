import 'dart:async';
import 'dart:math';
import 'package:esense_flutter/esense.dart';
import 'package:finalbird/background.dart';
import 'package:finalbird/enemy.dart';
import 'package:finalbird/enemyUp.dart';
import 'package:finalbird/homepage.dart';
import 'package:finalbird/routing.dart';

import 'package:flutter/material.dart';

import 'bird.dart';

class PlayPageTry extends StatefulWidget {
  const PlayPageTry({Key key}) : super(key: key);

  @override
  _PlayPageTryState createState() => _PlayPageTryState();
}

class _PlayPageTryState extends State<PlayPageTry>
    with SingleTickerProviderStateMixin {
  bool connected;
  Bird bird = Bird();
  double runDistance = 0;
  double runVelocity = 20;
  int score = 0;

  AnimationController worldController;
  Duration lastUpdate = Duration();

  List<EnemyUp> enemyUp = [EnemyUp(location: Offset(300, 250))];
  List<Enemy> enemyDown = [Enemy(location: Offset(200, 0))];
  List<Background> ground = [
    Background(location: Offset(0, 0)),
    Background(location: Offset(background.imageWidth / 10, 0))
  ];

  // ignore: avoid_init_to_null
  SensorEvent currentESenseEvent = null;

  String eSenseName = 'eSense-0115';

  StreamSubscription sub = null;

  bool isCalibrated = false;
  int calY = 0;
  int calZ = 0;

  @override
  void initState() {
    super.initState();
    listenToValues();

    worldController =
        AnimationController(vsync: this, duration: Duration(days: 10));
    worldController.addListener(_update);
    worldController.forward();
  }

  @override
  void dispose() {
    destroy();
    super.dispose();
  }

  destroy() {
    if (sub != null) sub.cancel();
  }

  void die() {
    setState(() {
      worldController.stop();
      bird.die();
    });
    GameOverDialog(context);
  }

  GameOverDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                  "Game Over\n"
                          "Score:" +
                      score.toString(),
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    destroy();
                    Routing.goHome(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];
    for (Background grounds in ground) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect groundsRect = grounds.getRect(screenSize, runDistance);
            return Positioned(
              left: groundsRect.left,
              top: groundsRect.top,
              width: groundsRect.width,
              height: groundsRect.height,
              child: grounds.render(),
            );
          }));
    }
    for (EnemyUp enemies in enemyUp) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect enemiesRect = enemies.getRect(screenSize, runDistance);
            return Positioned(
              left: enemiesRect.left,
              top: enemiesRect.top,
              width: enemiesRect.width,
              height: enemiesRect.height,
              child: enemies.render(),
            );
          }));
    }

    for (Enemy enemies in enemyDown) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect enemiesRect = enemies.getRect(screenSize, runDistance);
            return Positioned(
              left: enemiesRect.left,
              top: enemiesRect.top,
              width: enemiesRect.width,
              height: enemiesRect.height,
              child: enemies.render(),
            );
          }));
    }

    children.add(AnimatedBuilder(
        animation: worldController,
        builder: (context, _) {
          Rect birdRect = bird.getRect(screenSize, runDistance);
          return Positioned(
            left: birdRect.left,
            top: birdRect.top,
            width: birdRect.width,
            height: birdRect.height,
            child: bird.render(),
          );
        }));

    children.add(getScore());

    Widget toRet;
    if (currentESenseEvent != null) {
      final int y = currentESenseEvent.accel[1];
      final int z = currentESenseEvent.accel[2];
      if (isCalibrated == false) {
        calY = y;
        calZ = z;
        isCalibrated = true;
      }

      final normalY = y - calY;
      final normalZ = z - calZ;

      if (normalZ.abs() > 2000) {
        bird.flyUp();
      } else if (normalY.abs() > 2100) {
        switch (normalY.sign) {
          case -1:
            bird.goUp();
            break;
          case 1:
            bird.goDown();
            break;
        }
      }

      toRet = Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backbackground.png"),
                  fit: BoxFit.cover)),
          child: Stack(
            alignment: Alignment.center,
            children: children,
          ));
    } else {
      toRet = Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/loading.png"),
                  fit: BoxFit.fill)));
    }

    return Scaffold(body: toRet);
  }

  _update() {
    bird.update(lastUpdate, worldController.lastElapsedDuration);

    double elapsedTime =
        (worldController.lastElapsedDuration - lastUpdate).inMilliseconds /
            1000;
    runDistance += runVelocity * elapsedTime;

    Size screenSize = MediaQuery.of(context).size;
    Rect birdRect = bird.getRect(screenSize, runDistance).deflate(16);
    for (EnemyUp enemiesUp in enemyUp) {
      Rect obstacleRect = enemiesUp.getRect(screenSize, runDistance);

      if (birdRect.overlaps(obstacleRect.deflate(16))) {
        die();
      }
      if (obstacleRect.right < 0) {
        setState(() {
          enemyUp.remove(enemiesUp);
          enemyUp.add(EnemyUp(
              location: Offset(runDistance + Random().nextInt(100) + 50, 0)));
        });
        score += 5;
      }
    }

    for (Enemy enemiesDown in enemyDown) {
      Rect obstacleRect = enemiesDown.getRect(screenSize, runDistance);
      if (birdRect.overlaps(obstacleRect.deflate(17))) {
        die();
      }
      if (obstacleRect.right < 0) {
        setState(() {
          enemyDown.remove(enemiesDown);
          enemyDown.add(Enemy(
              location: Offset(runDistance + Random().nextInt(100) + 50, 0)));
        });
        score += 5;
      }
    }

    for (Background grounds in ground) {
      if (grounds.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          ground.remove(grounds);
          ground.add(Background(
              location: Offset(
                  ground.last.location.dx + background.imageWidth * 0.0833,
                  0)));
        });
      }
    }
    lastUpdate = worldController.lastElapsedDuration;
  }

  void listenToValues() async {
    sub = ESenseManager().sensorEvents.listen((event) {
      setState(() {
        currentESenseEvent = event;
      });
    });
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Text(
        "Score: " + score.toString(),
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
