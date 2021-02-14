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
import 'package:audiotales/resource/api/api.dart';
import 'package:provider/provider.dart';

class PuzzlesPage extends StatefulWidget {
  final RhymesList rhymesList;

  PuzzlesPage({Key key, this.rhymesList}) : super(key: key);

  @override
  _PuzzlesPageState createState() => _PuzzlesPageState();
}

class _PuzzlesPageState extends State<PuzzlesPage> {
  File _file;
  Directory dir;
  String fileName = "favoritePuzzles.json";
  bool fileExists = false;
  bool checkFavor = false;

  List<bool> showAnswer;

  Future<Map> puzzlesData() async {
    var url = widget.rhymesList.id;

    final response =
        await http.get('http://f2.audiobb.ru/files/10/$url.txt', headers: {
      'Accept-Encoding': 'gzip, deflate',
    });
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      Map puzls = spltiedPuzzels(decoded);

      showAnswer = List(puzls["puzzle"].length);
      return puzls;
    } else {
      return {"erorr": "error"};
    }
  }

  //? This spilts incoming text into puzzles and answers
  //? also removes <# #> from answers
  Map spltiedPuzzels(String puzzles) {
    List<String> lol = puzzles.split("\n\n");
    RegExp _separ = new RegExp("<#(.*?)#>");
    RegExp _answerSep = new RegExp("[<#>]");
    List<String> _answers = [];
    List<String> _puzzles = [];
    lol.forEach((el) {
      List<String> temp = el.split("\n");
      print(el);
      _puzzles.add(el.replaceAll(_separ, ""));
      _answers.add((temp[temp.length - 1]).replaceAll(_answerSep, ""));
    });

    print(lol);
    return {"puzzle": _puzzles, "answer": _answers};
  }

  // Icon falseFavIcon = new Icon(Icons.favorite_border);
  // Icon trueFavsIcon = Icon(Icons.favorite);
  @override
  void didChangeDependencies() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      _file = File(dir.path + "/" + fileName);
      fileExists = _file.existsSync();
      if (fileExists) {
        favoriteDataPuzzles = json.decode(_file.readAsStringSync());
        favoriteDataPuzzles =
            favoriteDataPuzzles.map((fav) => RhymesList.fromJson(fav)).toList();
      } else {
        createFile(dir, fileName);
      }
      setState(() {
        if (favoriteDataPuzzles.length > 0) {
          for (int i = 0; i < favoriteDataPuzzles.length; i++) {
            if (favoriteDataPuzzles[i].name == widget.rhymesList.name) {
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
    if (favoriteDataPuzzles.length > 0 && checkFavor == false) {
      for (int i = 0; i < favoriteDataPuzzles.length; i++) {
        if (favoriteDataPuzzles[i].name == widget.rhymesList.name) {
          checkFavor = true;
        }
      }
    }
  }

  void createFile(Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
  }

  InterstitialAd _interstitialAd;

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
    var widgetText = widget.rhymesList;

    void writeToFile() {
      checkFav();
      if (fileExists && checkFavor == false) {
        favoriteDataPuzzles.add(widgetText);
        _file.writeAsStringSync(json.encode(favoriteDataPuzzles));
      } else if (checkFavor == true) {
        favoriteDataPuzzles.removeWhere((item) => item.id == widgetText.id);
        _file.writeAsStringSync(json.encode(favoriteDataPuzzles));
      } else {
        createFile(dir, fileName);
      }
      favoriteDataPuzzles = json.decode(_file.readAsStringSync());
      favoriteDataPuzzles = favoriteDataPuzzles
          .map((fav) => new RhymesList.fromJson(fav))
          .toList();
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child:  Scaffold(
          appBar: new AppBar(
              title: new Text(widget.rhymesList.name),
              actions: <Widget>[
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
                      else if (checkFavor == false ||
                          favoriteDataPuzzles == null)
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
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: checkFavor
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border)),
                ),
              ]),
          body: Container(
              child: new FutureBuilder<Map>(
            future: puzzlesData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    itemCount: snapshot.data["puzzle"].length,
                    // ignore: missing_return
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        subtitle: Text("Нажмите, чтобы посмотреть отгадку"),
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        title: Container(
                          width: 300,
                          height: 300,
                          child: Card(
                            margin: EdgeInsets.all(0.0),
                            color: main_fg,
                            elevation: 3.0,
                            child: Center(
                              child: (showAnswer[index] == null)
                                  ? Text(
                                      snapshot.data["puzzle"][index],
                                      textAlign: TextAlign.center,
                                      style: (TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: main_text,
                                      )),
                                    )
                                  : Text(
                                      //? This is needed cause answers is coming in a lowercase
                                      snapshot.data["answer"][index][0]
                                              .toUpperCase() +
                                          snapshot.data["answer"][index]
                                              .substring(1),
                                      //?
                                      textAlign: TextAlign.center,
                                      style: (TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: main_text,
                                      )),
                                    ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showAnswer[index] = true;
                          });
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("Возникли некоторые проблемы");
              }
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )),
          floatingActionButton: Consumer<AudioPlayerProvider>(
            builder: (ctx, data, ch) => data.show(),
          ),
        ),
      
    );
  }
}
