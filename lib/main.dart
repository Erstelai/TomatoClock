import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tomato_clock/DateTool.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '認真助手'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var period = Duration(seconds: 1);
  bool countDownIsStart = false;
  int countDownSecond = 60*25;
  Timer _currentTimer;
  void startTimeCountDown() {
    if (_currentTimer != null) {
      return;
    }
    _currentTimer = Timer.periodic(period, (timer) {
      countDownIsStart = true;
      if (countDownSecond < 1) {
        timer.cancel();
        timer = null;
      } else {
        countDownSecond--;
      }
      setState(() {});
    });
  }


  void stopTimeCountDown() {
    countDownIsStart = false;
    _currentTimer.cancel();
    _currentTimer = null;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            child: Column(children: <Widget>[
              Card(
                  child: Container(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  child:  Text(
                    DateTool.getTimeString(countDownSecond),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
                  ),
                  onTap: () {
                    print('click title');
                  },
                )
              )),
              Container(
                padding: EdgeInsets.all(16),
                height: 200,
                child: Row(children: [
                  Container(
                      height: 200,
                      child: RaisedButton(
                        onPressed: () {
                          if (countDownIsStart == false) {
                            return;
                          }
                          stopTimeCountDown();
                        },
                        child: Text('Stop'),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        splashColor: Colors.black,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.white)),
                      )
                  ),
                  Container(
                    height: 200,
                    child: RaisedButton(
                      onPressed: () {
                        if (countDownIsStart == true) {
                          return;
                        }
                        startTimeCountDown();
                      },
                      child: Text('Start'),
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                      shape:
                      CircleBorder(side: BorderSide(color: Colors.white)),
                    ),
                  )
                ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
              Text('今日已認真了80分鐘'),
            ])));
  }
}
