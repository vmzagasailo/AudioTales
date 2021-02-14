import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotales/widgets/audioTales/player/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/globalData.dart';

class AudioPlayerProvider with ChangeNotifier {
  // PlayerState playerState = PlayerState.stopped;

  // get isPlaying => playerState == PlayerState.playing;

  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer get audioPlayerTest => audioPlayer;

  // Future<int> stop() async {
  //   final result = await audioPlayer.stop();
  //   if (result == 1) {
  //     playerState = PlayerState.stopped;
  //   }
  //   return result;
  // }

  var _buttonShow = false;
  void showButton(bool show) {
    _buttonShow = show;
    notifyListeners();
  }

  Widget show() {
    return _buttonShow
        ? FloatingActionButton(
            // onPressed: stop,
            onPressed: () {
              stop();
              showButton(false);
            },
            child: Icon(Icons.pause),
          )
        : Center();
  }
}