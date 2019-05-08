import 'package:flutter/material.dart';
import 'dart:convert';
import 'item.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  List<Item> _items;
  Map<String, int> _lastPages = {};

  static AppModel of(BuildContext context, {
    bool rebuildOnChange = false,
  }) => ScopedModel.of<AppModel>(context, rebuildOnChange: rebuildOnChange);

  void loadJson(String jsonStr) {
    JsonDecoder decoder = JsonDecoder();
    try {
      List<dynamic> decoded = decoder.convert(jsonStr);
      _items = List<Item>();
      decoded.forEach((val) {
        List<String> _urls = List<String>();
        for (String _url in val["urls"]) {
          _urls.add(_url);
        }
        _items.add(Item(code: val["code"], title: val["title"], urls: _urls));
      });
      notifyListeners();
    } on FormatException catch (e) {
      print(jsonStr);
      throw e;
    }
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

  void savePage(String code, int no) {
    _lastPages[code] = no;
  }

  int getLastPage(String code) {
    return _lastPages.containsKey(code) ? _lastPages[code] : 0;
  }
}
