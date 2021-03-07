import 'dart:async';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  @override
  ListItemWidget({Key key, String title}) : super(key: key) {
    this.title = title;
  }
  String title;
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(16),
            child:
            Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
            )
        )
    );
  }
}