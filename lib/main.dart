import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'widgets/items.dart';
import 'classes/appmodel.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
  ]);

  runApp(MyApp(model: AppModel()));
}

class MyApp extends StatelessWidget {
  final AppModel model;

  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        title: 'Para Para',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: Items(),
        routes: <String, WidgetBuilder>{
          '/items': (BuildContext context) => Items(),
        }),
    );
  }

}
