import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../classes/appmodel.dart';
import '../classes/item.dart';
import 'detail.dart';
import '../classes/constants.dart';
import 'package:scoped_model/scoped_model.dart';

class Items extends StatefulWidget {
  @override
  ItemsState createState() => ItemsState();
}

class ItemsState extends State<Items> {
  AppModel model;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    model = AppModel();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: _build(context),
    );
  }

  void _loadItems() async {
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

    setState(() {
      try {
        model.loadJson(jsonStr);
      } on FormatException {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: const Text("JSON error")));
        jsonFile.delete();
        exit(0);
      }
    });
  }

  Widget _buildItem(BuildContext context, String code) {
    Item item = model.item(code);
    return ListTile(
      leading: Icon(Icons.person, color: Colors.blueAccent, size: 30.0,),
      title: Text(
        item.title,
        style: TextStyle(color: Colors.cyan, fontSize: 20.0),
      ),
      subtitle: Text(
        '${item.urls.length} pieces',
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
      dense: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ScopedModel<AppModel>(
              model: model,
              child: Detail(code: item.code, parentKey: _scaffoldKey,),
            );
          }),
        );
      },
    );
  }

  Widget _build(BuildContext context) {
    if (model.items() == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Widget> _listItems = [];
    model.items().forEach((_item) {
      _listItems.add(_buildItem(context, _item.code));
      _listItems.add(Divider());
    });
    return SafeArea(
      child: ListView(
        children: _listItems,
      ),
    );
  }
}
