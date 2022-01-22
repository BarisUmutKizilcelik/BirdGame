import 'package:esense_flutter/esense.dart';
import 'package:finalbird/playpagetry.dart';
import 'package:finalbird/routing.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key key, this.connected, this.onConnectButtonPressed, this.deviceStatus})
      : super(key: key);
  final bool connected;
  final Function() onConnectButtonPressed;
  final String deviceStatus;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  eSenseDialog(BuildContext context) {
    widget.onConnectButtonPressed();
    return showDialog(
        context: context,
        builder: (context) {
          if (widget.connected == true) {
            return AlertDialog(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(widget.deviceStatus,
                    style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      print("$widget.connected");
                      Navigator.of(context).pop();
                    },
                    child: Text("OK", style: TextStyle(color: Colors.white)),
                  )
                ]);
          } else {
            return AlertDialog(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(widget.deviceStatus,
                    style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK", style: TextStyle(color: Colors.white)),
                  )
                ]);
          }
        });
  }

  void initState() {
    super.initState();
  }

  InformationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                  "Players can control the bird with their head movements via eSense.\n"
                  "Turn your head to right to jump over the obstacle or"
                  "Turn your head up or down to go the upper or lower lanes.\nThe objective is to get the highest score you can get.\nGood luck and have fun.",
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                )
              ]);
        });
  }

  FaultDialog(BuildContext context) {
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
              title: Text("Please connect eSense",
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    String path = "assets/images/newBack.png";
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(path), fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    if (widget.connected == true) {
                      Routing.goPlay(context);
                    } else {
                      FaultDialog(context);
                    }
                  },
                  child: Text("PLAY",
                      style: TextStyle(
                        fontSize: 25.0,
                      )),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 80), primary: Colors.green)),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    InformationDialog(context);
                  },
                  child: Text("HOW TO PLAY",
                      style: TextStyle(
                        fontSize: 25.0,
                      )),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 80), primary: Colors.amber)),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    eSenseDialog(context);
                  },
                  child: Text("eSense",
                      style: TextStyle(
                        fontSize: 25.0,
                      )),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 80), primary: Colors.red[900])),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
