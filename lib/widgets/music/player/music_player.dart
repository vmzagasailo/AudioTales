import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audiotales/main.dart';
import 'package:audiotales/modelJSON/admob.dart';
import 'package:audiotales/widgets/music/player/player_widget_music.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/widgets/defWidgets/def_list_img.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MusicPlayer extends StatefulWidget {
  MusicDetailsJSON musicDetailsJSON;

  MusicPlayer({Key key, this.musicDetailsJSON}) : super(key: key);
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String localFilePath;
  File jsonFile;
  Directory dir;
  bool fileExists = false;
  bool checkFavor = false;
  bool autoPlay;

  String fileNamePl = "playlistMusic.json";
  bool checkPlaylist = false;

  Icon truePlaylistIcon = Icon(Icons.playlist_add_check);
  Icon falsePlaylistIcon = Icon(Icons.playlist_add);

  int _total = 0, _received = 0;
  http.StreamedResponse _response;
  File _file;
  List<int> _bytes = [];

  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _checkPath();
    setState(() {
      if (audioPlaylist.length > 0) {
        for (int i = 0; i < audioPlaylist.length; i++) {
          if (audioPlaylist[i] == localFilePath) {
            checkPlaylist = true;
          }
        }
      }
    });
    check();
  }

  void check() {
    if (audioPlaylist.length > 0 && checkPlaylist == false) {
      for (int i = 0; i < audioPlaylist.length; i++) {
        if (audioPlaylist[i] == localFilePath) {
          checkPlaylist = true;
        }
      }
    }
  }

  void createFile(Directory dir, String fileNamePl) {
    File file = new File(dir.path + "/" + fileNamePl);
    file.createSync();
    fileExists = true;
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("musicList", musicList);

    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    musicList = prefs.getStringList('musicList');
  }

  void _savePlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("audioPlaylist", audioPlaylist);

    _loadPlaylist();
  }

  void _loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    audioPlaylist = prefs.getStringList('audioPlaylist');
  }

  void _checkPath() {
    var id = widget.musicDetailsJSON.id;

    if (musicList != null) {
      for (int i = 0; i < musicList.length; i++) {
        var count = File(musicList[i]).path.split('/').last;
        if (count == '$id.mp3') {
          localFilePath = musicList[i].toString();
          break;
        } else {
          localFilePath = null;
        }
      }
    } else
      localFilePath = null;
  }

  Future<void> _loadFile() async {
    var audioId = widget.musicDetailsJSON.id;
    // var playerURL= 'https://audiotales.exyte.top/music/$audioId.mp3';
    var playerURL = 'http://mp3.audiobb.ru/filemp3s/4/$audioId.mp3';
    _response =
        await http.Client().send(http.Request('GET', Uri.parse(playerURL)));
    _total = _response.contentLength;

    _response.stream.listen((value) {
      if (mounted) {
        setState(() {
          _bytes.addAll(value);
          _received += value.length;
        });
      }
    }).onDone(() async {
      final file = File(
          "${(await getApplicationDocumentsDirectory()).path}/$audioId.mp3");
      await file.writeAsBytes(_bytes);
      if (mounted) {
        setState(() {
          _file = file;
          localFilePath = file.path;
          musicList.add(localFilePath);
          _saveData();
        });
      }
    });
  }

  void deleteFromPlaylist() {
    for (int i = 0; i <= audioPlaylist.length; i++) {
      if (audioPlaylist.length > 0) {
        if (audioPlaylist[i] == localFilePath) {
          audioPlaylist.remove(localFilePath);
          audioPlaylist.remove(localFilePath);
          _savePlaylist();
          break;
        }
      }
    }
  }

  deleteDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Отмена"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Удалить"),
      onPressed: () {
        deleteFromPlaylist();
        setState(() {
          checkPlaylist = false;
        });
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Запись удалена",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black45,
            textColor: Colors.white,
            fontSize: 15.0);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Удалить аудиозапись"),
      content: Text(
          "Данная аудиозапись уже присуствует в вашем плейлисте, вы хотите ее удалить?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  double getBannerSize(double height) {
    double margin;
    if (height <= 400) {
      margin = 32;
    } else if (height > 400 && height <= 720) {
      margin = 50;
    } else if (height >= 720) {
      margin = 90;
    }
    return margin;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double devicePadding = padding.bottom + padding.top;
    var deviceSize = MediaQuery.of(context).size;
    var dur = widget.musicDetailsJSON.duration;
    var id = widget.musicDetailsJSON.id;
    var widgetMusic = widget.musicDetailsJSON;
    var rating = widget.musicDetailsJSON.rating;

    double _value = 0.0;

    void _setValue(double value) => setState(() => _value = value);
    String imageURL = 'https://data.audiobb.ru/files/img/$id.jpg';

    final appBar = AppBar(
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_player.jpg'),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(bottom: 7, right: 5, top: 7),
          child: IconButton(
            icon: checkPlaylist ? truePlaylistIcon : falsePlaylistIcon,
            onPressed: () => setState(
              () => {
                check(),
                if (localFilePath != null && checkPlaylist == false)
                  {
                    audioPlaylist.add(localFilePath),
                    _savePlaylist(),
                    checkPlaylist = true,
                    Fluttertoast.showToast(
                        msg: "Добавлено в ваш плейлист",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 15.0),
                  }
                else if (localFilePath == null)
                  {
                    Fluttertoast.showToast(
                        msg: "Установите аудиосказку",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 15.0),
                  }
                else if (checkPlaylist == true)
                  {
                    deleteDialog(context),
                  },
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_player.jpg'),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(bottom: 7, top: 7, right: 5),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.star,
                    color: Colors.black54,
                    size: 18,
                  ),
                ),
                Text(
                  rating,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: main_text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: main_fg,
        appBar: appBar,
        body: Container(
          height: ((deviceSize.height * 1) -
                  (appBar.preferredSize.height +
                      getBannerSize(deviceSize.height - devicePadding).toDouble())) *
              1,
          width: deviceSize.width * 1,
          decoration: BoxDecoration(
            //sborder: Border.all(color: Colors.yellow),
            image: DecorationImage(
                image: AssetImage('assets/background_player.jpg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: ((deviceSize.height * 1) -
                        (appBar.preferredSize.height +
                            getBannerSize(deviceSize.height - devicePadding).toDouble())) *
                    0.43,
                width: deviceSize.width * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.musicDetailsJSON.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                      child: Hero(
                        tag: id,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: (Platform.isIOS &&
                                  widget.musicDetailsJSON.iosImage == '1')
                              ? imageUrlDefAudio
                              : imageURL,
                          width: deviceSize.width * 0.7,
                          height: ((deviceSize.height * 1) -
                                  (appBar.preferredSize.height +
                                      getBannerSize(deviceSize.height - devicePadding)
                                          .toDouble())) *
                              0.3,
                          placeholder: (context, url) => Image.asset(
                            imageUrlDefAudio,
                            width: deviceSize.width * 0.7,
                            height: ((deviceSize.height * 1) -
                                    (appBar.preferredSize.height +
                                        getBannerSize(deviceSize.height - devicePadding)
                                            .toDouble())) *
                                0.3,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            imageUrlDefAudio,
                            width: deviceSize.width * 0.7,
                            height: ((deviceSize.height * 1) -
                                    (appBar.preferredSize.height +
                                        getBannerSize(deviceSize.height - devicePadding)
                                            .toDouble())) *
                                0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              localFilePath == null
                  ? Container(
                      height: ((deviceSize.height * 1) -
                              (appBar.preferredSize.height +
                                  getBannerSize(deviceSize.height - devicePadding)
                                      .toDouble())) *
                          0.5,
                      width: deviceSize.width * 1,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Slider(value: _value, onChanged: _setValue),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  '00:00',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                  '$dur',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              elevation: 10.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.red),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/logo/playButtonFalse.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: SizedBox(
                                  width: deviceSize.width * 0.17,
                                  height: deviceSize.height * 0.10,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: _total > 0
                                        ? Text(
                                            ((_received / _total) * 100)
                                                    .toStringAsFixed(0) +
                                                "%",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        : Text(''),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                autoPlay = true;
                                _loadFile();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: ((deviceSize.height * 1) -
                              (appBar.preferredSize.height +
                                  getBannerSize(deviceSize.height - devicePadding)
                                      .toDouble())) *
                          0.5,
                      child: MusicPlayerWidget(
                        url: localFilePath,
                        autoPlay: autoPlay,
                        musicDetailsJSON: widget.musicDetailsJSON,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
