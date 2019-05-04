import 'package:flutter/material.dart';
import '../classes/item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';
import '../classes/util.dart';
import 'dart:typed_data';

class Detail extends StatefulWidget {
  Item item;

  Detail({Key key, @required this.item});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<Detail> {
  int progress;
  List<File> images;
  int currentNo;

  @override
  void initState() {
    super.initState();
    progress = 0;
    images = null;
    currentNo = 0;
    _readImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    if (images == null) {
      return SafeArea(
        child: _progress(),
      );
    }

    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _image(currentNo),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.cyan,
                splashColor: Colors.yellow,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                onPressed: currentNo < 1 ? null : () {
                  setState(() {
                    currentNo -= 1;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "${currentNo + 1}/${images.length}",
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.cyan,
                splashColor: Colors.yellow,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
                onPressed: images.length <= currentNo + 1 ? null : () {
                  setState(() {
                    currentNo += 1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Image _image(int no) {
    Uint8List decrypted = Util.decrypt(images[no].readAsBytesSync());
    return Image.memory(decrypted);
  }

  Widget _progress() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("Now loading...", style: TextStyle(fontSize: 30.0),),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: SizedBox(
            height: 30.0,
            child: LinearProgressIndicator(
              value: progress / 100,
            )
          ),
        ),
        Text("$progress%", style: TextStyle(fontSize: 30.0),),
      ],
    );
  }

  void _readImages() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory imageDir = Directory("${docDir.path}/${widget.item.code}");
    if (!imageDir.existsSync()) {
      await imageDir.create(recursive: true);
      await _downloadImages(imageDir.path);
    }

    var _images;

    try {
      var files = await imageDir.list().toList();
      _images = <File>[];
      for (FileSystemEntity entity in files) {
        _images.add(entity as File);
      }
    } on FileSystemException {
      return;
    }

    setState(() {
      images = _images;
      progress = 100;
    });
  }

  Future<void> _downloadImages(String saveDir) async {
    int total = widget.item.urls.length;
    int counter = 0;
    for (String url in widget.item.urls) {
      counter++;
      http.Response response = await http.get(url);
      File file = File(sprintf("%s/%03d.jpg", [saveDir, counter]));
      await file.writeAsBytes(response.bodyBytes);
      try {
        setState(() {
          progress = counter / total * 100.0 ~/ 1.0;
        });
      } catch (e) {
        Directory dir = Directory(saveDir);
        var files = await dir.list().toList();
        for (var file in files) {
          await (file as File).delete();
        }
        dir.delete();
        return;
      }
    }
  }
}