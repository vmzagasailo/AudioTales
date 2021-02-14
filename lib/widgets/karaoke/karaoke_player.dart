import 'dart:async';
import 'dart:convert';

import 'package:audiotales/main.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/widgets/audioTales/audio_tales.dart';
import 'package:audiotales/widgets/audioTales/player/player_widget.dart';
import 'package:audiotales/widgets/karaoke/karaoke.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floating_action_row/floating_action_row.dart';
import '../../providers/audioPlayerProvider.dart';

class KaraokePlayer extends StatefulWidget {
  final KaraokeDetailsJSON karaokeDetailsJSON;

  KaraokePlayer({Key key, this.karaokeDetailsJSON}) : super(key: key);

  @override
  KaraokePlayerState createState() => KaraokePlayerState();
}

class KaraokePlayerState extends State<KaraokePlayer> {
  bool _notDownloading = false;

  String trackUrl = 'http://f2.audiobb.ru/files/5/3968.mp3';
  String wordsUrl = 'http://f2.audiobb.ru/files/5/3968.txt';

  String tempText = "";
  List<String> _texts = [];
  String _musics = "";
  String tempLyrics = "...";
  List lyrics = [];
  List<int> timeCodes = [];
  int tempindex = 0;

  int _total = 0, _received = 0;
  http.StreamedResponse _response;
  List<int> _bytes = [];
  String localFilePath;

  File jsonFile;
  Directory dir;
  String fileName = "favoriteKaraoke.json";
  bool fileExists = false;
  bool checkFavor = false;

  bool checkMusic = true;

  Icon playPause = Icon(Icons.pause);

  @override
  void didChangeDependencies() {
    _checkPath();
    // if (!_notDownloading)
    _loadFile();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataKaraoke = json.decode(jsonFile.readAsStringSync());
        favoriteDataKaraoke = favoriteDataKaraoke
            .map((fav) => KaraokeDetailsJSON.fromJson(fav))
            .toList();
      } else {
        createFile(dir, fileName);
      }
      setState(() {
        if (favoriteDataKaraoke.length > 0) {
          for (int i = 0; i < favoriteDataKaraoke.length; i++) {
            if (favoriteDataKaraoke[i].name == widget.karaokeDetailsJSON.name) {
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
    if (favoriteDataKaraoke.length > 0 && checkFavor == false) {
      for (int i = 0; i < favoriteDataKaraoke.length; i++) {
        if (favoriteDataKaraoke[i].name == widget.karaokeDetailsJSON.name) {
          checkFavor = true;
        } else
          checkFavor = false;
      }
    }
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("karaokePlaylist", karaokePlaylist);
    prefs.setStringList("karaokeWordsList", karaokeWordsList);
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    karaokePlaylist = prefs.getStringList('karaokePlaylist');
    karaokeWordsList = prefs.getStringList('karaokeWordsList');
  }

  // download file on phone
  Future<void> _loadFile() async {
    var tempid = 3968;
    var audioId = widget.karaokeDetailsJSON.id;
    var playerURL = 'http://f2.audiobb.ru/files/5/$tempid.mp3';

    http.Response _res = await http.get(wordsUrl, headers: {
      'Accept': '*/*',
      'Content-Type': "charset=UTF-8",
      'charset': 'windows-1251',
      'Accept-Language': 'ru',
      'Accept-Encoding': 'gzip, deflate',
      'Connection': 'close',
    });

    tempText = utf8.decode(_res.bodyBytes);
    karaokeWordsList.add(tempText);

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
          "${(await getApplicationDocumentsDirectory()).path}/$tempid.mp3");
      await file.writeAsBytes(_bytes);
      if (!mounted) return;
      setState(() {
        localFilePath = file.path;
        karaokePlaylist.add(localFilePath);
        _notDownloading = true;
        _musics = localFilePath;
        _saveData();
      });
    });
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void createFile(Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
  }

  // checking exist file in phone
  void _checkPath() {
    // for testing purposes
    String auidoid = '3968';
    String wordsid = '3968';
    if (karaokePlaylist != null) {
      for (int i = 0; i < karaokePlaylist.length; i++) {
        var count = File(karaokePlaylist[i]).path.split('/').last;
        if (count == '$auidoid.mp3') {
          localFilePath = karaokePlaylist[i].toString();
          tempText = karaokeWordsList[i].toString();
          _musics = localFilePath;
          _notDownloading = true;
          break;
        } else {
          localFilePath = null;
        }
      }
    } else
      localFilePath = null;
  }

  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;

  Future<int> _stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      playerState = PlayerState.stopped;
    }
    return result;
  }

  Future<int> _pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      playerState = PlayerState.paused;
    }
    checkMusic = false;
    return result;
  }

  Future<int> _resume() async {
    final result = await audioPlayer.resume();
    if (result == 1) {
      playerState = PlayerState.playing;
    }
    checkMusic = true;
    return result;
  }

  Future<int> _play(url) async {
    final result = await audioPlayer.play(url, isLocal: true);
    if (result == 1) {
      playerState = PlayerState.playing;

      audioPlayer.setPlaybackRate(playbackRate: 1.0);

      return result;
    }
  }

  // this one changes lyrics according to music
  lyricsFlow() {
    audioPlayer.onAudioPositionChanged.listen((p) {
      print(p.inSeconds.toString());
      if (p.inSeconds == (timeCodes[tempindex] / 10)) {
        print(lyrics[tempindex]);
        setState(() {
          tempLyrics = lyrics[tempindex];
          tempindex++;
        });
      }
    });
  }

  buildList(BuildContext context) {
    textToLyrics();
    var deviceSize = MediaQuery.of(context).size;

    if (checkMusic) {
      _play(_musics);
    }

    lyricsFlow();

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: (deviceSize.height - bannerAd.size.height) * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  imageUrlDefAudio,
                  width: imageItems,
                  height: imageItems,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: (deviceSize.height - bannerAd.size.height) * 0.4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: tempText.length > 0
                      ? Text(
                          tempLyrics,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        )
                      : Center(),
                ),
              ),
            )
          ]),
    );
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
        final dir = Directory(localFilePath);
        dir.deleteSync(recursive: true);
        filmstripList.remove(localFilePath);
        _stop();
        localFilePath = null;
        var route =  MaterialPageRoute(
          builder: (BuildContext context) =>  Karaoke(),
        );
        Navigator.of(context).push(route);
        _saveData();
        Fluttertoast.showToast(
            msg: "Запись удалена",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Удалить аудиозапись"),
      content: Text("Вы действительно хотите удалить аудиозапись?"),
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

  // Converting incoming text into timeline and lyrics
  void textToLyrics() {
    var separ = new RegExp("<#(.*?)#>");

    lyrics = tempText.split(separ);
    lyrics.remove("");

    separ = new RegExp("[^<#0-9>]");

    List<String> _preTimes = tempText.split(separ);

    separ = new RegExp("[<#>]");

    _preTimes.forEach((el) {
      if (el.startsWith("<")) {
        timeCodes.add(int.parse(el.replaceAll(separ, "")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var karaokeObject = widget.karaokeDetailsJSON;
    var appBar = AppBar(
      title: Text(widget.karaokeDetailsJSON.name),
      backgroundColor: header,
    );
    void writeToFile() {
      checkFav();
      if (fileExists && checkFavor == false) {
        favoriteDataKaraoke.add(karaokeObject);
        jsonFile.writeAsStringSync(json.encode(favoriteDataKaraoke));
      } else if (checkFavor == true) {
        favoriteDataKaraoke.removeWhere((item) => item.id == karaokeObject.id);
        jsonFile.writeAsStringSync(json.encode(favoriteDataKaraoke));
      } else {
        createFile(dir, fileName);
      }
      favoriteDataKaraoke = json.decode(jsonFile.readAsStringSync());
      favoriteDataKaraoke = favoriteDataKaraoke
          .map((fav) => new KaraokeDetailsJSON.fromJson(fav))
          .toList();
    }

    var children = List<Widget>();
    children.add(
      FloatingActionRowButton(
        icon: checkFavor == false
            ? Icon(Icons.favorite_border)
            : Icon(Icons.favorite, color: Colors.red),
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
            else if (checkFavor == false || favoriteDataKaraoke == null)
              {
                karaokeObject.favorite = true,
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
      ),
    );
    children.add(
      FloatingActionRowButton(
        icon: Icon(Icons.delete_forever),
        onTap: () {
          deleteDialog(context);
        },
      ),
    );

    children.add(
      FloatingActionRowButton(
        icon: Icon(Icons.refresh),
        onTap: () {
          setState(() {
            if (_musics.isNotEmpty && checkMusic) {
              tempLyrics = "...";
              _stop();
              _play(_musics);
              checkMusic = true;
            }
          });
        },
      ),
    );
    children.add(
      FloatingActionRowButton(
        icon: playPause,
        onTap: () {
          setState(() {
            if (playerState == PlayerState.playing) {
              checkMusic = false;
              playPause = Icon(Icons.play_arrow);
              _pause();
            } else if (playerState == PlayerState.paused) {
              checkMusic = true;
              playPause = Icon(Icons.pause);
              _resume();
            }
          });
        },
      ),
    );

    // pauseOnTap() {
    //   (playerState == PlayerState.playing) ? _pause() : _resume();
    // }

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Container(
          child: Center(
            child: _musics.length < 1
                ? Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: _total > 0
                              ? Text(
                                  'Идет загрузка... ' +
                                      ((_received / _total) * 100)
                                          .toStringAsFixed(0) +
                                      "%",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black))
                              : Text(''))
                    ],
                  ))
                : buildList(context),
          ),
        ),
        floatingActionButton: Visibility(
          visible: _notDownloading,
          child: Padding(
            padding: EdgeInsets.only(top: 100.0, left: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: FloatingActionRow(
                children: children,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      // onTap: pauseOnTap(),
    );
  }
}
