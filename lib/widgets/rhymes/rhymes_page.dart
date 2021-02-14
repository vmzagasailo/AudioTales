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

class RhymesPage extends StatefulWidget {
  final RhymesList rhymesList;

  RhymesPage({Key key, this.rhymesList}) : super(key: key);

  @override
  _RhymesPageState createState() => _RhymesPageState();
}

class _RhymesPageState extends State<RhymesPage> {
  File jsonFile;
  Directory dir;
  String fileName = "favoriteTexts.json";
  bool fileExists = false;
  bool checkFavor = false;

  Future<String> textURL() async {
    var url = widget.rhymesList.id;

    final response =
        await http.get('http://f2.audiobb.ru/files/1/$url.txt', headers: {
      'Accept-Encoding': 'gzip, deflate',
    });
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      return decoded;
    } else {
      return "Error";
    }
  }

  var sizeControl = 20.0;

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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: 
        Scaffold(
          appBar: AppBar(title: Text(widget.rhymesList.name), actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () => setState(
                () => {
                  if (sizeControl <= 40) {sizeControl++}
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () => setState(
                () => {
                  if (sizeControl >= 5) {sizeControl--}
                },
              ),
            ),
          ]),
          body: Container(
            child: new FutureBuilder<String>(
              future: textURL(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                      title: SingleChildScrollView(
                    child: Text(snapshot.data,
                        style: TextStyle(fontSize: sizeControl)),
                  ));
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
          floatingActionButton: Consumer<AudioPlayerProvider>(
            builder: (ctx, data, ch) => data.show(),
          ),
        ),
      
    );
  }
}
