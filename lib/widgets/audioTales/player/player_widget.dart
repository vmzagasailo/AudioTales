import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/audioPlayerProvider.dart';

import '../audio_tales.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  final String url;
  AudioTaleDetailsJSON audioTaleDetailsJSON;
  bool autoPlay;

  PlayerWidget({this.url, this.autoPlay, this.audioTaleDetailsJSON});

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, autoPlay);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  //audio player
  String url;
  bool autoPlay;
  Duration _duration;
  Duration _position;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  bool checkRepeat = false;
  bool checkConsistent = false;

  //Timer
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool startT = true;
  bool stopT = true;
  int timeForTimer = 0;
  bool checkTimer = true;
  String timeToDisplay = "";

  //load json
  File jsonFile;
  Directory dir;
  String fileName = "favoriteAudioTale.json";
  bool fileExists = false;
  //File _file;
  bool isChekcPl = false;

  bool checkFavor = false;

  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;

  // get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  // get _positionText => _position?.toString()?.split('.')?.first ?? '';
  // get _durationFull => _durationText.toString()?.split('0:')?.last ?? '';
  // get _positionFull => _positionText?.toString()?.split('0:')?.last ?? '';

  get _durationFull => _durationText.toString()?.split('0:')?.last ?? '';
  get _positionFull => _positionText?.toString()?.split('0:')?.last ?? '';
  get _durationText =>
      _duration != null ? _duration.toString().split('.').first : '';

  get _positionText =>
      _position != null ? _position.toString().split('.').first : '';

  _PlayerWidgetState(this.url, this.autoPlay);
  var playerData;
  @override
  void didChangeDependencies() {
    playerData = Provider.of<AudioPlayerProvider>(context, listen: false);
    _initAudioPlayer();
    autoPlayAfterDownload();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataAudioTale = json.decode(jsonFile.readAsStringSync());
        favoriteDataAudioTale = favoriteDataAudioTale
            .map((fav) => AudioTaleDetailsJSON.fromJson(fav))
            .toList();
      } else {
        createFile(dir, fileName);
      }
      setState(() {
        if (favoriteDataAudioTale.length > 0) {
          for (int i = 0; i < favoriteDataAudioTale.length; i++) {
            if (favoriteDataAudioTale[i].name ==
                widget.audioTaleDetailsJSON.name) {
              checkFavor = true;
            }
          }
        }
      });
    });
    _play();
    checkFav();
    super.didChangeDependencies();
  }

//checking exists audio in favorite JSON
  void checkFav() {
    if (favoriteDataAudioTale.length > 0 && checkFavor == false) {
      for (int i = 0; i < favoriteDataAudioTale.length; i++) {
        if (favoriteDataAudioTale[i].name == widget.audioTaleDetailsJSON.name) {
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
  void _savePlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("audioPlaylist", audioPlaylist);

    _loadPlaylist();
  }

  void _loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    audioPlaylist = prefs.getStringList('audioPlaylist');
  }

  void autoPlayAfterDownload() {
    if (autoPlay == true && autoPlay != null) {
      _play();
    }
  }

  void startTimer() {
    if (!mounted) return;
    setState(() {
      startT = false;
      stopT = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    Timer.periodic(
        Duration(
          seconds: 1,
        ), (Timer t) {
      if (!mounted) return;
      setState(() {
        if (timeForTimer < 1 || checkTimer == false) {
          t.cancel();
          checkTimer = true;
          timeToDisplay = "";
          startT = true;
          stopT = true;
          _stop();
          Navigator.of(context).pop();
        } else if (timeForTimer < 60) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.floor().toString().padLeft(2, '0') +
              ":" +
              s.floor().toString().padLeft(2, '0');
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.floor().toString().padLeft(2, '0') +
              ":" +
              s.floor().toString().padLeft(2, '0');
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay = h.floor().toString().padLeft(2, '0') +
              ":" +
              m.floor().toString().padLeft(2, '0') +
              ":" +
              s.floor().toString().padLeft(2, '0');

          timeForTimer = timeForTimer - 1;
        }
      });
    });
    Navigator.of(context).pop();
  }

  void stopTimer() {
    setState(() {
      startT = true;
      stopT = true;
      checkTimer = false;
    });
  }

  void deleteFromPlaylist() {
    for (int i = 0; i <= audioPlaylist.length; i++) {
      if (audioPlaylist.length > 0) {
        if (audioPlaylist[i] == url) {
          audioPlaylist.remove(url);
          _savePlaylist();
          break;
        }
      }
    }
  }

  void _removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("audioTaleList", audioTaleList);
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
        final dir = Directory(url);
        dir.deleteSync(recursive: true);
        audioTaleList.remove(url);
        deleteFromPlaylist();
        _stop();
        url = null;
        // var route = new MaterialPageRoute(
        //   builder: (BuildContext context) => new AudioTalePage(),
        // );
        Navigator.of(context).pushNamed('/audioTale');
        //Navigator.of(context).pop();
        _removeData();
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

  _playBackRate(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Отмена"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget rate = FlatButton(
      child: Text("0.5"),
      onPressed: () {
        setState(() {
          playbackRate = 0.5;
          _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
          Navigator.of(context).pop();
        });
      },
    );
    Widget rate1 = FlatButton(
      child: Text("1.0"),
      onPressed: () {
        setState(() {
          playbackRate = 1.0;
          _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
          Navigator.of(context).pop();
        });
      },
    );
    Widget rate15 = FlatButton(
      child: Text("1.5"),
      onPressed: () {
        setState(() {
          playbackRate = 1.5;
          _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
          Navigator.of(context).pop();
        });
      },
    );
    Widget rate2 = FlatButton(
      child: Text("2.0"),
      onPressed: () {
        setState(() {
          playbackRate = 2.0;
          _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
          Navigator.of(context).pop();
        });
      },
    );
    Widget rate25 = FlatButton(
      child: Text("2.5"),
      onPressed: () {
        setState(() {
          playbackRate = 2.5;
          _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
          Navigator.of(context).pop();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Скорость возпроизведения"),
      content: SizedBox(
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Если вы хотите изменить скорость воспроизведение, выберете нужный вам рейт?"),
              rate,
              rate1,
              rate15,
              rate2,
              rate25,
            ],
          )),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget timerDialog(BuildContext context) {
    var timerSize = MediaQuery.of(context).size;
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        'Установить таймер',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      content: Container(
        width: timerSize.width * 0.8,
        height: timerSize.height * 0.4,
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 10), child: Text('час')),
                  NumberPicker.integer(
                      initialValue: hour,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (val) {
                        setState(() {
                          hour = val;
                        });
                      })
                ],
              ),
              Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10), child: Text('мин')),
                NumberPicker.integer(
                    initialValue: min,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (val) {
                      setState(() {
                        min = val;
                      });
                    })
              ]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: startT ? startTimer : null,
                  color: Colors.green,
                  child: Text('НАЧАТЬ', style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: stopT ? null : stopTimer,
                  color: Colors.red,
                  child: Text('СТОП', style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
            ],
          )
        ]),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void choiceAction(int choice) {
    if (choice == 1) {
      _playBackRate(context);
    } else if (choice == 2) {
      deleteDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var audioId = widget.audioTaleDetailsJSON.id;
    var audioDetailsJSON = widget.audioTaleDetailsJSON;
    var deviceSize = MediaQuery.of(context).size;

    if (_audioPlayerState == AudioPlayerState.COMPLETED) {
      _stop();
      if (checkRepeat == true) {
        _play();
      }
    }

    Future<void> _share() async {
      await FlutterShare.share(
        title: 'Приложение "Сказки"',
        text: 'Привет, с тобой поделились адуиофайлом с нашего приложения',
        linkUrl: (Platform.isIOS)
            ? 'Аудио: https://audiotales.exyte.top/audiotale/$audioId.mp3 \n'
                'Приложение: https://apps.apple.com/ua/app/%D0%B0%D1%83%D0%B4%D0%B8%D0%BE%D1%81%D0%BA%D0%B0%D0%B7%D0%BA%D0%B8-%D0%B8-%D0%B4%D0%B5%D1%82%D1%81%D0%BA%D0%B0%D1%8F-%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B0/id1512361026?l=ru'
            : 'Аудио: https://audiotales.exyte.top/audiotale/$audioId.mp3 \n'
                'Приложение: https://play.google.com/store/apps/details?id=best.audio.tales.and.filmstrips.for.children',
      );
    }

    void writeToFile() {
      checkFav();
      if (fileExists && checkFavor == false) {
        favoriteDataAudioTale.add(audioDetailsJSON);
        jsonFile.writeAsStringSync(json.encode(favoriteDataAudioTale));
      } else if (checkFavor == true) {
        favoriteDataAudioTale.removeWhere((item) => item.id == audioId);
        jsonFile.writeAsStringSync(json.encode(favoriteDataAudioTale));
      }
      favoriteDataAudioTale = json.decode(jsonFile.readAsStringSync());
      favoriteDataAudioTale = favoriteDataAudioTale
          .map((fav) => AudioTaleDetailsJSON.fromJson(fav))
          .toList();
    }

    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.green)),
      child: Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Slider(
                  activeColor: main_fg,
                  onChanged: (v) {
                    final position = v * _duration.inMilliseconds;
                    audioPlayer.seek(Duration(milliseconds: position.round()));
                  },
                  value: (_position != null &&
                          _duration != null &&
                          _position.inMilliseconds > 0 &&
                          _position.inMilliseconds < _duration.inMilliseconds)
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  _position != null
                      ? '${_positionText ?? ''}'
                      : _duration != null
                          ? _durationText
                          : '0:00:00',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text(
                  Platform.isAndroid
                      ? (_position != null
                          ? '${_durationText ?? ''}'
                          : _duration != null
                              ? _durationText
                              : '0:00:00')
                      //: widget.audioTaleDetailsJSON.duration,
                      : (widget.audioTaleDetailsJSON.duration.length == 5)
                          ? '0:' + widget.audioTaleDetailsJSON.duration
                          : widget.audioTaleDetailsJSON.duration,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          // Container(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          //   child:

          //левый ряд кнопок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                child: Column(
                  children: <Widget>[
                    MaterialButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/logo/backgroundButton.png'),
                            )),
                        child: SizedBox(
                          width: deviceSize.width * 0.34,
                          height: deviceSize.height * 0.06,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ОТПРАВИТЬ',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _share();
                      },
                    ),

                    //
                    MaterialButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/logo/backgroundButton.png'),
                            )),
                        child: SizedBox(
                          width: deviceSize.width * 0.34,
                          height: deviceSize.height * 0.06,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'УДАЛИТЬ',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        deleteDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              //центральная кнопка
              Column(children: <Widget>[
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: (isPlaying)
                              ? AssetImage('assets/logo/buttonPause.png')
                              : AssetImage('assets/logo/playButtonTrue.png'),
                          fit: BoxFit.fill),
                    ),
                    child: SizedBox(
                      width: deviceSize.width * 0.17,
                      height: deviceSize.height * 0.10,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(''),
                      ),
                    ),
                  ),
                  onPressed: isPlaying ? () => _pause() : () => _play(),
                ),
              ]),
              //правый ряд кнопок
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                child: Column(
                  children: <Widget>[
                    MaterialButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/logo/backgroundButton.png'),
                            )),
                        child: SizedBox(
                          width: deviceSize.width * 0.34,
                          height: deviceSize.height * 0.06,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              timeToDisplay != "" ? timeToDisplay : 'ТАЙМЕР',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        timerDialog(context);
                      },
                    ),
                    //
                    MaterialButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/logo/backgroundButton.png'),
                            )),
                        child: SizedBox(
                          width: deviceSize.width * 0.34,
                          height: deviceSize.height * 0.06,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              checkFavor == false ||
                                      favoriteDataAudioTale == null
                                  ? 'ДОБАВИТЬ В ЛЮБИМОЕ'
                                  : 'УДАЛИТЬ ИЗ ЛЮБИМОГО',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () => setState(
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
                              favoriteDataMusic == null)
                            {
                              audioDetailsJSON.favorite = true,
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
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 0.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => _checkRepeat()),
                      child: Container(
                        height: deviceSize.height * 0.06,
                        width: 55,
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: checkRepeat
                                    ? AssetImage('assets/logo/loopingOn.png')
                                    : AssetImage('assets/logo/loopingOff.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _checkConsistent()),
                      child: Container(
                        height: deviceSize.height * 0.06,
                        width: 55,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: checkConsistent
                                    ? AssetImage('assets/logo/LButtonOn.png')
                                    : AssetImage('assets/logo/LButtonOff.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkRepeat() {
    if (checkRepeat == false) {
      checkRepeat = true;
      Fluttertoast.showToast(
          msg: "Зацикливание этого трека включено",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      checkRepeat = false;
      Fluttertoast.showToast(
          msg: "Зацикливание этого трека выключено",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  void _checkConsistent() {
    if (checkConsistent == false) {
      checkConsistent = true;
      Fluttertoast.showToast(
          msg: "Последовательное проигрование включенно",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      checkConsistent = false;
      Fluttertoast.showToast(
          msg: "Последовательное проигрование выключено",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  void _initAudioPlayer() {
    _audioPlayer = audioPlayerTest;
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
      });
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        _audioPlayer.startHeadlessService();
        _audioPlayer.setNotification(
            title: widget.audioTaleDetailsJSON.name,
            artist: widget.audioTaleDetailsJSON.author,
            imageUrl:
                'https://audiotales.exyte.top/imageItems/${widget.audioTaleDetailsJSON.id}.png',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _audioPlayer.onAudioPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position;
      });
    });

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      if (!mounted) return;
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      if (!mounted) return;
      setState(() {
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  Future<void> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() => playerState = PlayerState.playing);
      playerData.showButton(true);
    }

    if (playbackRate == null) {
      _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    } else {
      _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
    }
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => playerState = PlayerState.paused);
      playerData.showButton(false);
    }

    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        playerState = PlayerState.stopped;
        _position = Duration();
      });
      playerData.showButton(false);
    }
    return result;
  }

  void _onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }
}
