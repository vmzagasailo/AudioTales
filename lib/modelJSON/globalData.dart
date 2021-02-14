import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audiotales/widgets/audioTales/player/player_widget.dart';

//Audio player
PlayerState playerState = PlayerState.stopped;

get isPlaying => playerState == PlayerState.playing;

AudioPlayer audioPlayer = AudioPlayer();
AudioPlayer get audioPlayerTest => audioPlayer;

Future<int> stop() async {
  final result = await audioPlayer.stop();
  if (result == 1) {
    playerState = PlayerState.stopped;
  }
  return result;
}

double playbackRate;

//Path to audio
List<String> audioTaleList = [];

//Path to archive
List<String> filmstripList = [];

//Path to films
List<String> filmsList = [];

//playlistPath
List<String> audioPlaylist = [];

//Path to music
List<String> musicList = [];

List<String> listKaraoke = [];

//fav
List<dynamic> favoriteDataAudioTale = [];
List<dynamic> favoriteDataText = [];
List<dynamic> favoriteDataMusic = [];

List<dynamic> favoriteDataFilmstrip = [];
List<dynamic> favoriteDataKaraoke = [];
List<dynamic> favoriteDataPuzzles = [];

// //playlist
// List<dynamic> playlistMusicData = [];
// List<dynamic> playlistAudioTaleData = [];




//fontSize
double fontSize = 20.0;
double fontSizeDesc = 18.0;
double fontSizeCount = 18.0;

//control ios_content
List<String> iosDisable = [
  '55',
  '69',
  '504',
];

//imageDefault
const String imageUrlDefAudio = 'assets/defaultAudioImage.jpg';
const String imageUrlDefVideo = 'assets/defaultVideoImage.jpg';
const String imageUrlDefText = 'assets/defaultTextImage.jpg';

const double imageSets = 100.0;
const double imageItems = 200.0;

var paddingBanner = 89.0;
var filmstripFS = 18.0; // Filmstrip text font size

const Color main_bg = Color.fromRGBO(216, 185, 131, 1);
const Color header = Color.fromRGBO(127, 255, 212, 1);
const Color main_fg = Color.fromRGBO(252, 241, 230, 1);

const Color desc_text = Color.fromRGBO(255, 255, 255, 1);
const Color main_text = Color.fromRGBO(0, 0, 0, 1);
const Color icons_color = Color.fromRGBO(0, 0, 0, 1);

const Color fav_color = Color.fromRGBO(236, 64, 122, 1);

//playlistPath
List<String> karaokePlaylist = [];
List<String> karaokeWordsList = [];

bool check = false;

//counts category in menu
var countFilmstrip = 261;
var countAudiotale = 1648;
var countFilm = 27;
var countCartoon = 61;
var countText = 6890;
var countMusic = 1065;
var countKaraoke = 80;
var countRhymes = 50;
var countPuzzles = 1254;

//show menu on start app
bool isOpenDrawerOnStart = false;
