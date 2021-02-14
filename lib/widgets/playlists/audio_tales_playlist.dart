import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/widgets/audioTales/player/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:audiotales/providers/audioPlayerProvider.dart';

class AudioPlaylist extends StatefulWidget {
  final List<String> urls;

  AudioPlaylist({this.urls});

  @override
  State<StatefulWidget> createState() {
    return _AudioPlaylistState(urls);
  }
}

class _AudioPlaylistState extends State<AudioPlaylist> {
  List<String> urls;

  //audio player
  String url;
  bool autoPlay;
  Duration _duration;
  Duration _position;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  //Timer
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool startT = true;
  bool stopT = true;
  int timeForTimer = 0;
  String timeToDisplay = "";
  bool checkTimer = true;

  bool checkFavor = false;

  int i = 0;

  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;

  // get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  // get _positionText => _position?.toString()?.split('.')?.first ?? '';
  get _durationFull => _durationText.toString()?.split('0:')?.last ?? '';
  get _positionFull => _positionText?.toString()?.split('0:')?.last ?? '';
  get _durationText =>
      _duration != null ? _duration.toString().split('.').first : '';

  get _positionText =>
      _position != null ? _position.toString().split('.').first : '';

  _AudioPlaylistState(this.urls);
  var playerData;

  @override
  void initState() {
    playerData = Provider.of<AudioPlayerProvider>(context, listen: false);
    _initAudioPlayer();
    if(audioPlaylist.length > 0) {
      _play();
    }
    super.initState();
   
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

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      // decoration:
      //     BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      height: deviceSize.height * 0.2,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.all(10.0),
                elevation: 10.0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.lightBlue),
                  child: SizedBox(
                    width: 110.0,
                    height: 40.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          timeToDisplay != "" ? timeToDisplay : 'ТАЙМЕР',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                onPressed: () {
                  timerDialog(context);
                },
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/logo/skipPreviously.png'),
                              fit: BoxFit.fill),
                        ),
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(''),
                          ),
                        ),
                      ),
                      onTap: () => _skipPrev(),
                    ),
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: isPlaying
                                  ? AssetImage('assets/logo/buttonPause.png')
                                  : AssetImage(
                                      'assets/logo/playButtonTrue.png'),
                              fit: BoxFit.fill),
                        ),
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(''),
                          ),
                        ),
                      ),
                      onTap: isPlaying ? () => _pause() : () => _play(),
                    ),
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/logo/skipNext.png'),
                              fit: BoxFit.fill),
                        ),
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(''),
                          ),
                        ),
                      ),
                      onTap: () => _skipNext(),
                    ),
                  ),
                ],
              )
            ],
          ),
          //
          Stack(
            children: [
              Slider(
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
          //
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Align(
              alignment: Alignment.centerLeft,
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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _position != null
                    ?
                    // '${_durationText ?? ''}'
                    // :
                    // _duration != null
                    //     ?
                    _durationText
                    : '0:00:00',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = audioPlayerTest;
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
      });
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

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(urls[i], position: playPosition);
    if (result == 1) {
      setState(() => playerState = PlayerState.playing);
      playerData.showButton(true);
    }

    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _skipNext() async {
    _stop();
    if (i < urls.length) {
      i++;
      if (i == urls.length) {
        i--;
        _stop();
      }
      final result = await _audioPlayer.play(urls[i]);
      if (result == 1) {
        setState(() => playerState = PlayerState.playing);
        playerData.showButton(true);
      }
      return result;
    }
  }

  Future<int> _skipPrev() async {
    if (i > 0) {
      i--;
      final result = await _audioPlayer.play(urls[i]);
      if (result == 1) {
        setState(() => playerState = PlayerState.playing);
        playerData.showButton(true);
      }

      return result;
    }
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
