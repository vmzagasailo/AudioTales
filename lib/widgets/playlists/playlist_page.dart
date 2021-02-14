

import 'package:audiotales/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_tales_playlist.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/modelJSON/globalData.dart';

class PlaylistPage extends StatefulWidget {
  final TaleInf taleInf;
  final AudioTaleDetailsJSON audioTaleDetailsJSON;

  PlaylistPage({Key key, this.taleInf, this.audioTaleDetailsJSON})
      : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  void _loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    audioPlaylist = prefs.getStringList('audioPlaylist');
    if (audioPlaylist == null) {
      audioPlaylist = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main_bg,
      appBar: AppBar(
        title: Text('Плейлист'),
      ),
      body: Column(
        children: [
          Wrap(children: <Widget>[
            AudioPlaylist(urls: audioPlaylist),
          ]),
          Wrap(children: <Widget>[
            audioPlaylist == null
                ? Text("В очереди нету треков",style: TextStyle(fontSize: fontSize),)
                : Text("У вас в очереди треков: " +
                    audioPlaylist.length.toString(),style: TextStyle(fontSize: fontSize),),
          ])
        ],
      ),
    );
  }
}
