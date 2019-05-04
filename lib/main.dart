import 'package:flutter/material.dart';
import 'widgets/items.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
  ]);

  runApp(MaterialApp(
      title: 'Para Para',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Items(),
      routes: <String, WidgetBuilder>{
        '/items': (BuildContext context) => Items(),
      }));
}