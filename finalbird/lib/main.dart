import 'package:esense_flutter/esense.dart';
import 'package:finalbird/playpagetry.dart';
import 'package:finalbird/routing.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool connected = false;
  String _deviceStatus = 'Connect Device';
  String eSenseName = 'eSense-0115';

  @override
  void initState() {
    super.initState();
    _listenToESense();

    Routing.goHome = (BuildContext context) =>
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(
              connected: connected,
              deviceStatus: _deviceStatus,
              onConnectButtonPressed: () => _connectToESense());
        }));

    Routing.goPlay = (BuildContext context) =>
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const PlayPageTry();
        }));
  }

  Future _listenToESense() async {
    ESenseManager().connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      setState(() {
        connected = false;
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = 'connected';
            connected = true;
            break;
          case ConnectionType.unknown:
            _deviceStatus = 'unknown';
            connected = false;
            break;
          case ConnectionType.disconnected:
            _deviceStatus = 'disconnected';
            connected = false;
            break;
          case ConnectionType.device_found:
            _deviceStatus = 'device_found';
            connected = false;
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = 'device_not_found';
            connected = false;
            break;
        }
      });
    });
  }

  Future _connectToESense() async {
    print('connecting... connected: $connected');
    if (!ESenseManager().connected) await ESenseManager().connect(eSenseName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
          connected: connected,
          deviceStatus: _deviceStatus,
          onConnectButtonPressed: () => _connectToESense()),
    );
  }
}
