import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tomato_clock/DateTool.dart';
import 'package:tomato_clock/TimeSelectedWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TomatoClock());
}

class TomatoClock extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '認真助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeWidget(title: '認真助手'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final String Last_Select_Time_Local_Key = 'lastSelectTime';
  var period = Duration(seconds: 1);
  bool _countDownIsStart = false;
  int _countDownSecond = 60*25; // countDown var
  int _selectedStudyTime = 60*25; // record user current studyTime
  int _studyTime = 0; // display study time
  bool isGetLastStudyTime = false;
  Timer _currentTimer;
  void startTimeCountDown() {
    if (_currentTimer != null) {
      return;
    }
    _currentTimer = Timer.periodic(period, (timer) {
      _countDownIsStart = true;
      if (_countDownSecond < 1) {
        _didFinishCountDown();
      } else {
        _countDownSecond--;
      }
      setState(() {}); // 更新倒數畫面
    });
  }
  // MARK: Private Func
  void _didFinishCountDown() {
    _currentTimer.cancel();
    _currentTimer = null;
    saveFinishedStudyTime();
    _countDownIsStart = false;
    _countDownSecond = _selectedStudyTime; // reset count down sec
  }
  void saveFinishedStudyTime() async {
    setState(() {
      _studyTime = _studyTime + _selectedStudyTime;
    });
    // use daily string to get daily data
    // ex: 2021/3/4 => key
    String todayDateStr = DateTool.getTodayFormatDateString();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int currentStudyTime = prefs.getInt(todayDateStr);
    await prefs.setInt(todayDateStr, _studyTime);

  }

  void stopTimeCountDown() {
    _countDownIsStart = false;
    _currentTimer.cancel();
    _currentTimer = null;
    setState(() {});
  }

  void _saveLastSelectedStudyTime(int lastSelectedTime) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(Last_Select_Time_Local_Key, lastSelectedTime);
  }

  void _getLastSelectedStudyTime() async {
    if (isGetLastStudyTime == true) {
      return;
    }
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
      int lastTimeSelectedStudyTime = prefs.getInt(Last_Select_Time_Local_Key) ?? 0;
      isGetLastStudyTime = true;
      if (lastTimeSelectedStudyTime > 0) {
        setState(() {
          _countDownSecond = lastTimeSelectedStudyTime;
          _selectedStudyTime = lastTimeSelectedStudyTime;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    getTodayStudyTime();
    _getLastSelectedStudyTime();
    String todayTotalStudyTimeStr = DateTool.getMinutes(_studyTime);
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
                    DateTool.getTimeString(_countDownSecond),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
                  ),
                  onTap: () {
                    pushToSelectedTimeWidget(context);
                  }
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
                          if (_countDownIsStart == false) {
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
                        if (_countDownIsStart == true) {
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
              Text('今日已認真了$todayTotalStudyTimeStr分鐘'),
            ])));
  }
  void pushToSelectedTimeWidget(BuildContext context) async {
    final selectedFuture = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeSelectedWidget()));
        setState(() {
          _countDownSecond = int.parse(selectedFuture);
          _studyTime = _countDownSecond;
          _selectedStudyTime = _countDownSecond;
          // save user selected studyTime
          _saveLastSelectedStudyTime(int.parse(selectedFuture));
        });
  }
  Future getTodayStudyTime() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String todayDateStr = DateTool.getTodayFormatDateString();
    setState(() {
      _studyTime = prefs.getInt(todayDateStr) ?? 0;
    });
  }
}
