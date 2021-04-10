import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tomato_clock/DateTool.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CountDownWidget extends StatefulWidget {
  // MARK: Private property
  _CountDownState currentState;
  int countDownSec;

  // TODO: Notify outside when countdown finished
  // MARK: Init Function
  CountDownWidget(this.countDownSec);

  @override
  _CountDownState createState() {
    currentState = _CountDownState();
    currentState._countDownSecond = countDownSec;
    return currentState;
  }

  void updateCountDownSec(int countDownSec) {
    currentState._countDownSecond = countDownSec;
  }
  void startTimerCount({Function() callback}) {
    currentState.startTimeCountDown(callback: callback);
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
  int _countDownSecond;

  // MARK: Public Functions
  void startTimeCountDown({Function() callback}) {
    if (_currentTimer != null || _isCountDownStart == true) {
      return;
    }
    _currentTimer = Timer.periodic(_period, (timer) {
      _isCountDownStart = true;
      if (_countDownSecond < 1) {
        callback();
        _didFinishCountDown();
      } else {
        _countDownSecond--;
      }
      setState(() {});
    });
  }
  void pauseTimeCountDown() {
    if (_isCountDownStart == false ) {
      return;
    }
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

