import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tomato_clock/DateTool.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CountDownWidget extends StatefulWidget {
  _CountDownState currentState;
  @override
  _CountDownState createState() {
    currentState = _CountDownState();
    return currentState;
  }

  void startTimerCount() {
    currentState.startTimeCountDown();
  }
  void pauseTimerCount() {
    currentState.pauseTimeCountDown();
  }
}

class _CountDownState extends State<CountDownWidget> {
  // MARK: Private Property
  Timer _currentTimer;
  var _period = Duration(seconds: 1);
  bool _isCountDownStart = false;
  int _countDownSecond = 60*25;
  int _selectedStudyTime = 60*25;
  int _lastSelectedTme; // loda data
  final String Last_Select_Time_Local_Key = 'lastSelectTime';

  // MARK: Public Functions
  void startTimeCountDown() {
    if (_currentTimer != null) {
      return;
    }
    _currentTimer = Timer.periodic(_period, (timer) {
      _isCountDownStart = true;
      if (_countDownSecond < 1) {
        _didFinishCountDown();
      } else {
        _countDownSecond--;
      }
      setState(() {});
    });
  }
  void pauseTimeCountDown() {
    _isCountDownStart = false;
    _currentTimer.cancel();
    _currentTimer = null;
    setState(() {});
  }
  // MARK: Private Functions

  void _didFinishCountDown() {
    _currentTimer.cancel();
    _currentTimer = null;
    _isCountDownStart = false;
    _countDownSecond = _selectedStudyTime;
  }
  void _saveFinishedStudyTime() async {
    // callback to HomeWidget
    // use daily string to get daily data
    // ex: 2021/3/20 => key
    String todayDateStr = DateTool.getTodayFormatDateString();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int currentStudyTime = prefs.getInt(todayDateStr);
    await prefs.setInt(todayDateStr, _selectedStudyTime);
  }

  void _saveLastSelectedStudyTime() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(Last_Select_Time_Local_Key, _lastSelectedTme);
  }

  void _getLastSelectedStudyTime() async {
    // do it when init state
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int lastTimeSelectedStudyTime = prefs.getInt(Last_Select_Time_Local_Key) ?? 0;
    if (lastTimeSelectedStudyTime > 0) {
      setState(() {
        _countDownSecond = lastTimeSelectedStudyTime;
        _selectedStudyTime = lastTimeSelectedStudyTime;
      });
    }
  }


  // MARK: Override Functions
  @override
  void initState() {
    super.initState();
    // Init function
  }
  @override
  Widget build(BuildContext context) {
    return Card (
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          DateTool.getTimeString(_countDownSecond),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
        ),
      ),
    );
  }
}

