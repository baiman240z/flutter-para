import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'widgets/items.dart';
import 'classes/appmodel.dart';
import 'classes/constants.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
  ]);

  var model = AppModel();
  _loadItems(model);
  runApp(MyApp(model: model));
}

void _loadItems(AppModel model) async {
  Directory dir = await getApplicationDocumentsDirectory();
  File jsonFile = File("${dir.path}/items.json");
  String jsonStr;
  if (jsonFile.existsSync()) {
    jsonStr = await jsonFile.readAsString();
  } else {
    http.Response response =
    await http.get('${Constants.API_URL}list');
    jsonStr = response.body;
    jsonFile.writeAsString(response.body);
  }

  try {
    model.loadJson(jsonStr);
  } on FormatException {
    jsonFile.delete();
    exit(0);
  }
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
