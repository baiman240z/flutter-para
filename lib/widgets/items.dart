import 'package:flutter/material.dart';
import '../classes/appmodel.dart';
import '../classes/item.dart';
import 'detail.dart';

class Items extends StatefulWidget {
  @override
  ItemsState createState() => ItemsState();
}

class ItemsState extends State<Items> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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

  Widget _buildItem(BuildContext context, String code) {
    final model = AppModel.of(context, rebuildOnChange: true);
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
            return Detail(item: item, parentKey: _scaffoldKey,);
          }),
        );
      },
    );
  }

  Widget _build(BuildContext context) {
    final model = AppModel.of(context, rebuildOnChange: true);
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
