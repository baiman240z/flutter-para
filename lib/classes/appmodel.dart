import 'dart:convert';
import 'item.dart';

class AppModel {
  List<Item> _items;

  AppModel(String jsonStr) {
    JsonDecoder decoder = JsonDecoder();
    List<dynamic> decoded = decoder.convert(jsonStr);
    _items = List<Item>();
    decoded.forEach((val) {
      List<String> _urls = List<String>();
      for (String _url in val["urls"]) {
        _urls.add(_url);
      }
      _items.add(Item(code: val["code"], title: val["title"], urls: _urls));
    });
  }

  List<Item> items() {
    return _items;
  }

  Item item(String code) {
    for (Item item in _items) {
      if (code == item.code) {
        return item;
      }
    }
    return null;
  }
}
