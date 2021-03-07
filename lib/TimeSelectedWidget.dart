import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tomato_clock/DateTool.dart';

import 'Widget/ListItemWidget.dart';

class TimeSelectedWidget extends StatelessWidget {
  // MARK: Override Functions
  final List<int> timeDataList = [25 * 60, 20 * 60, 15 * 60, 10 * 60, 5 * 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: timeDataList.length,
            itemBuilder: (BuildContext itemContext, int index) {
              return GestureDetector(
                child: ListItemWidget(title: DateTool.getTimeString(timeDataList[index])),
                onTap: () {
                  Navigator.pop(context, timeDataList[index].toString());
                },
              );
            }));
  }
}
