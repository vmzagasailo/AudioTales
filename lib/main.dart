import 'dart:io';

import 'package:audiotales/providers/audioPlayerProvider.dart';
import 'package:audiotales/widgets/cartoons/cartoons.dart';
import 'package:audiotales/widgets/films/films.dart';
import 'package:audiotales/widgets/filmstrips/filmstrips.dart';
import 'package:audiotales/widgets/karaoke/karaoke_details.dart';
import 'package:audiotales/widgets/music/music_details.dart';
import 'package:audiotales/widgets/search/search_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audiotales/widgets/audioTales/audio_tales.dart';
import 'package:audiotales/widgets/music/music.dart';
import 'package:audiotales/widgets/texts/texts.dart';
import 'package:audiotales/widgets/favorites/favorites.dart';
import 'package:audiotales/widgets/playlists/playlist_page.dart';
import 'package:audiotales/widgets/karaoke/karaoke.dart';
import 'package:audiotales/widgets/hints/hints.dart';
import 'package:audiotales/widgets/rhymes/rhymes.dart';
import 'package:audiotales/widgets/puzzles/puzzles.dart';
import 'package:audiotales/widgets/audioTales/audio_tale_details.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:provider/provider.dart';
import './providers/talesProvider.dart';

import 'modelJSON/admob.dart';

RateMyApp _rateMyApp = RateMyApp();

BannerAd bannerAd;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: header));
  WidgetsFlutterBinding.ensureInitialized();
  _rateMyApp.init().then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AudioPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TalesProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato',
          brightness: Brightness.light,
          primaryColor: header,
          accentColor: Colors.cyan[600],
        ),
        initialRoute: '/audioTale',
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          var padding = MediaQuery.of(context).padding;
          var screenSize = MediaQuery.of(context).size;
          double screenHeight =
              screenSize.height - (padding.bottom + padding.top);

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

          myBanner();
          _loadData();
          _loadDataMusic();
          _loadDataArchive();
          _loadPlaylist();
          return Container(
            color: main_fg,
            child: widget,
            padding: EdgeInsets.only(bottom: getBannerSize(screenHeight)),
          );
        },
        routes: {
          '/audioTale': (BuildContext context) => AudioTalePage(),
          '/audioTaleDetails': (BuildContext context) => AudioTaleDetails(),
          '/music': (BuildContext context) => MusicPage(),
          '/musicDetails': (BuildContext context) => MusicDetails(),
          '/karaoke': (BuildContext context) => Karaoke(),
          '/karaokeDetails': (BuildContext context) => KaraokeDetails(),
          '/filmstrips': (BuildContext context) => Filmstrips(),
          '/cartoons': (BuildContext context) => Cartoons(),
          '/films': (BuildContext context) => Films(),
          '/texts': (BuildContext context) => Texts(),
          '/rhymes': (BuildContext context) => Rhymes(),
          '/puzzles': (BuildContext context) => Puzzles(),
          '/favorite': (BuildContext context) => Favorites(),
          '/audioPlaylist': (BuildContext context) => PlaylistPage(),
          '/search': (BuildContext context) => SearchPage(),
          '/hints': (BuildContext context) => Hints(),
        },
        home: AudioTalePage(),
      ),
    ));
    _rateMyApp.conditions.forEach((condition) {
      if (condition is DebuggableCondition) {}
    });
  });
}

BannerAd myBanner() {
  bannerAd = BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          bannerAd.show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
        } else if (event == MobileAdEvent.failedToLoad) {
          paddingBanner = 1.0;
          main();
        }
      })
    ..load();
}

void _loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  audioTaleList = prefs.getStringList('audioTaleList');
  if (audioTaleList == null) {
    audioTaleList = [];
  }
}

void _loadPlaylist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  audioPlaylist = prefs.getStringList('audioPlaylist');
  if (audioPlaylist == null) {
    audioPlaylist = [];
  }
}

void _loadDataMusic() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  musicList = prefs.getStringList('musicList');
  if (musicList == null) {
    musicList = [];
  }
}

void _loadDataArchive() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  filmstripList = prefs.getStringList('filmstripList');
  if (filmstripList == null) {
    filmstripList = [];
  }
}

class NavDrawer extends StatelessWidget {
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Приложение "Сказки"',
      text:
          'Привет, Переходи и загружай наше приложение: "Сказки", ждем тебя!<3',
      linkUrl: (Platform.isIOS)
          ? 'https://apps.apple.com/ua/app/%D0%B0%D1%83%D0%B4%D0%B8%D0%BE%D1%81%D0%BA%D0%B0%D0%B7%D0%BA%D0%B8-%D0%B8-%D0%B4%D0%B5%D1%82%D1%81%D0%BA%D0%B0%D1%8F-%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B0/id1512361026?l=ru'
          : 'https://play.google.com/store/apps/details?id=best.audio.tales.and.filmstrips.for.children',
    );
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
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width * 0.8,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.15,
              decoration: BoxDecoration(
                color: header,
              ),
            ),
            ListTile(
              leading: Icon(Icons.headset, color: Colors.black),
              title: Text(
                'Аудиосказки',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countAudiotale.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/audioTale')},
            ),
            ListTile(
              leading: Icon(Icons.music_note, color: Colors.black),
              title: Text(
                'Музыка',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countMusic.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/music')},
            ),
            ListTile(
              leading: Icon(Icons.mic, color: Colors.black),
              title: Text(
                'Караоке',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countKaraoke.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/karaoke')},
            ),
            ListTile(
              leading: Icon(Icons.picture_in_picture, color: Colors.black),
              title: Text(
                'Диафильмы',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countFilmstrip.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/filmstrips')},
            ),
            ListTile(
              leading: Icon(Icons.local_movies, color: Colors.black),
              title: Text(
                'Мультики',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countCartoon.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/cartoons')},
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: Colors.black),
              title: Text(
                'Фильмы',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countFilm.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/films')},
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.black),
              title: Text(
                'Тексты',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countText.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/texts')},
            ),
            ListTile(
              leading: Icon(Icons.child_care, color: Colors.black),
              title: Text(
                'Потешки',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countRhymes.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/rhymes')},
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.black),
              title: Text(
                'Загадки',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              trailing: Text(countPuzzles.toString(),
                  style: TextStyle(color: Colors.black45)),
              onTap: () => {Navigator.pushNamed(context, '/puzzles')},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.black),
              title: Text(
                'Любимое',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => {Navigator.pushNamed(context, '/favorite')},
            ),
            ListTile(
              leading: Icon(Icons.queue_music, color: Colors.black),
              title: Text(
                'Плейлист',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => {
                _loadPlaylist(),
                Navigator.pushNamed(context, '/audioPlaylist')
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.black),
              title: Text(
                'Поиск',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => {Navigator.pushNamed(context, '/search')},
            ),
            ListTile(
              leading: Icon(Icons.question_answer, color: Colors.black),
              title: Text(
                'Советы',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => {Navigator.pushNamed(context, '/hints')},
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.red),
              title: Text('Полная версия',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(color: Colors.red, fontSize: fontSize)),
              onTap: () => {Navigator.of(context).pushReplacementNamed('/')},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.thumb_up, color: Colors.black),
              title: Text(
                'Оставить отзыв',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => _rateMyApp.showRateDialog(context),
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.black),
              title: Text(
                'Отправить',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
              onTap: () => share(),
            ),
            Divider(),
            Text(
              'Build version 1.2.7(22)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
