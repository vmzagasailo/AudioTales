import 'dart:convert';
import 'dart:io';

import 'package:audiotales/modelJSON/admob.dart';
import 'package:audiotales/providers/audioPlayerProvider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:provider/provider.dart';

class TextPage extends StatefulWidget {
  final TextDetailsJSON textDetailsJSON;

  TextPage({Key key, this.textDetailsJSON}) : super(key: key);

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  File jsonFile;

  Directory dir;
  String fileName = "favoriteText.json";
  bool fileExists = false;
  bool checkFavor = false;

  var sizeControl = 20.0;

  InterstitialAd _interstitialAd;

  Future<String> textURL() async {
    var url = widget.textDetailsJSON.id;
    final response =
        await http.get('https://f2.audiobb.ru/files/9/$url.txt', headers: {
      'Accept-Encoding': 'gzip, deflate',
    });
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      return decoded;
    } else {
      return "Error";
    }
  }

  @override
  void didChangeDependencies() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataText = json.decode(jsonFile.readAsStringSync());
        favoriteDataText = favoriteDataText
            .map((fav) => TextDetailsJSON.fromJson(fav))
            .toList();
      } else {
        createFile(dir, fileName);
      }
      setState(() {
        if (favoriteDataText.length > 0) {
          for (int i = 0; i < favoriteDataText.length; i++) {
            if (favoriteDataText[i].name == widget.textDetailsJSON.name) {
              checkFavor = true;
            }
          }
        }
      });
    });
    checkFav();
    super.didChangeDependencies();
  }

  void checkFav() {
    if (favoriteDataText.length > 0 && checkFavor == false) {
      for (int i = 0; i < favoriteDataText.length; i++) {
        if (favoriteDataText[i].name == widget.textDetailsJSON.name) {
          checkFavor = true;
        } else
          checkFavor = false;
      }
    }
  }

  void createFile(Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
  }

  InterstitialAd myInterstitial() {
    _interstitialAd = InterstitialAd(
        adUnitId: getInterstitialAdUnitId(),
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _interstitialAd.show(anchorType: AnchorType.bottom);
          }
          if (event == MobileAdEvent.opened ||
              event == MobileAdEvent.clicked ||
              event == MobileAdEvent.failedToLoad) {
            Navigator.of(context).pop(true);
          }
        })
      ..load();
  }

  Future<bool> _onWillPop() async {
    myInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    var widgetText = widget.textDetailsJSON;

    void writeToFile() {
      checkFav();
      if (fileExists && checkFavor == false) {
        favoriteDataText.add(widgetText);
        jsonFile.writeAsStringSync(json.encode(favoriteDataText));
      } else if (checkFavor == true) {
        favoriteDataText.removeWhere((item) => item.id == widgetText.id);
        jsonFile.writeAsStringSync(json.encode(favoriteDataText));
      } else {
        createFile(dir, fileName);
      }
      favoriteDataText = json.decode(jsonFile.readAsStringSync());
      favoriteDataText =
          favoriteDataText.map((fav) => TextDetailsJSON.fromJson(fav)).toList();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child:Scaffold(
          appBar: AppBar(
              title: Text(widget.textDetailsJSON.name),
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () => setState(() => {
                        if (sizeControl <= 40) {sizeControl++}
                      }),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () => setState(() => {
                        if (sizeControl >= 5) {sizeControl--}
                      }),
                ),
                GestureDetector(
                  onTap: () => setState(
                    () => {
                      checkFav(),
                      if (checkFavor)
                        {
                          writeToFile(),
                          checkFavor = false,
                          Fluttertoast.showToast(
                              msg: "Удалено из любимых!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 15),
                        }
                      else if (checkFavor == false || favoriteDataText == null)
                        {
                          widgetText.favorite = true,
                          writeToFile(),
                          checkFavor = true,
                          Fluttertoast.showToast(
                              msg: "Добавлено в любимое!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 15),
                        }
                    },
                  ),
                  child: Container(
                      child: checkFavor
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border)),
                ),
              ]),
          floatingActionButton: Consumer<AudioPlayerProvider>(
          builder: (ctx, data, ch) => data.show(),
        ),
          body: Container(
            child: new FutureBuilder<String>(
              future: textURL(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new ListTile(
                    title: new SingleChildScrollView(
                      child: new Text(snapshot.data,
                          style: TextStyle(fontSize: sizeControl)),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Возникли некоторые проблемы");
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      
    );
  }
}
