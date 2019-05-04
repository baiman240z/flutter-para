import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../classes/appmodel.dart';
import '../classes/item.dart';
import 'detail.dart';
import '../classes/constants.dart';

class Items extends StatefulWidget {
  @override
  ItemsState createState() => ItemsState();
}

class ItemsState extends State<Items> {
  AppModel model;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      model = AppModel(jsonStr);
    });
  }

  Widget _buildItem(BuildContext context, String code) {
    Item item = model.item(code);
    return  Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        color: Colors.indigo,
        splashColor: Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.teal,
              ),
              Padding(padding: EdgeInsets.only(right: 5.0),),
              Text(
                item.title,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail(item: item,)),
          );
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    if (model == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Widget> _listItems = [];
    model.items().forEach((_item) {
      _listItems.add(_buildItem(context, _item.code));
    });
    return SafeArea(
      child: ListView(
        children: _listItems,
      ),
    );
  }
}
