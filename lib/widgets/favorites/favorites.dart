import 'dart:convert';
import 'dart:io';

import 'package:audiotales/widgets/filmstrips/filmsrtrip_archive.dart';
import 'package:audiotales/widgets/karaoke/karaoke_player.dart';
import 'package:audiotales/widgets/puzzles/puzzles_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/main.dart';
import 'package:audiotales/widgets/texts/text_page.dart';
import 'package:audiotales/widgets/music/player/music_player.dart';
import 'package:audiotales/widgets/audioTales/player/audio_tales_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import '../../providers/audioPlayerProvider.dart';
import 'package:provider/provider.dart';
import 'package:audiotales/main.dart';

class Favorites extends StatefulWidget {
  Favorites({
    Key key,
  }) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  File jsonFile;
  Directory dir;
  String favoriteAudioTale = "favoriteAudioTale.json";
  String favoriteText = "favoriteText.json";
  String favoriteMusic = "favoriteMusic.json";
  String favoriteFilmstrip = "favoriteFilmstrip.json";
  String favoritePuzzles = "favoritePuzzles.json";
  String favoriteKaraoke = "favoriteKaraoke.json";
  String favoriteFilms = "favoritesFilms.json";

  bool fileExists = false;
  String pathToLocal;

  int _selectedIndex = 0;
  int index = 0;

  Icon ratingIcon = Icon(
    Icons.star,
    color: Colors.black,
  );
  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = File(dir.path + "/" + favoriteAudioTale);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataAudioTale = json.decode(jsonFile.readAsStringSync());
          favoriteDataAudioTale = favoriteDataAudioTale
              .map((fav) => AudioTaleDetailsJSON.fromJson(fav))
              .toList();
        }
      });
    }
    if (index == 1) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = File(dir.path + "/" + favoriteMusic);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataMusic = json.decode(jsonFile.readAsStringSync());
          favoriteDataMusic = favoriteDataMusic
              .map((fav) => MusicDetailsJSON.fromJson(fav))
              .toList();
        }
      });
    }
    if (index == 2) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = File(dir.path + "/" + favoriteKaraoke);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataKaraoke = json.decode(jsonFile.readAsStringSync());
          favoriteDataKaraoke = favoriteDataKaraoke
              .map((fav) => KaraokeDetailsJSON.fromJson(fav))
              .toList();
        }
      });
    }
    if (index == 3) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = new File(dir.path + "/" + favoriteFilmstrip);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataFilmstrip = json.decode(jsonFile.readAsStringSync());
          favoriteDataFilmstrip = favoriteDataFilmstrip
              .map((fav) => new FilmstripDetailsJSON.fromJson(fav))
              .toList();
        }
      });
    }
    if (index == 4) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = new File(dir.path + "/" + favoriteText);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataText = json.decode(jsonFile.readAsStringSync());
          favoriteDataText = favoriteDataText
              .map((fav) => new TextDetailsJSON.fromJson(fav))
              .toList();
        }
      });
    }
    if (index == 5) {
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        jsonFile = new File(dir.path + "/" + favoritePuzzles);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          favoriteDataPuzzles = json.decode(jsonFile.readAsStringSync());
          favoriteDataPuzzles = favoriteDataPuzzles
              .map((fav) => new RhymesList.fromJson(fav))
              .toList();
        }
      });
    }
  }

  var deviceSize;
  final appBar = AppBar(
    title: Text('Любимое'),
  );

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoriteAudioTale);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataAudioTale = json.decode(jsonFile.readAsStringSync());
        favoriteDataAudioTale = favoriteDataAudioTale
            .map((fav) => AudioTaleDetailsJSON.fromJson(fav))
            .toList();
      }
      _onItemTapped(index);
    });
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoriteMusic);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataMusic = json.decode(jsonFile.readAsStringSync());
        favoriteDataMusic = favoriteDataMusic
            .map((fav) => MusicDetailsJSON.fromJson(fav))
            .toList();
      }
      _onItemTapped(index);
    });
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoriteKaraoke);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataKaraoke = json.decode(jsonFile.readAsStringSync());
        favoriteDataKaraoke = favoriteDataKaraoke
            .map((fav) => KaraokeDetailsJSON.fromJson(fav))
            .toList();
      }
      _onItemTapped(index);
    });
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoriteFilmstrip);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataFilmstrip = json.decode(jsonFile.readAsStringSync());
        favoriteDataFilmstrip = favoriteDataFilmstrip
            .map((fav) => FilmstripDetailsJSON.fromJson(fav))
            .toList();
      }
      _onItemTapped(index);
    });
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoriteText);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataText = json.decode(jsonFile.readAsStringSync());
        favoriteDataText = favoriteDataText
            .map((fav) => TextDetailsJSON.fromJson(fav))
            .toList();
      }
      _onItemTapped(index);
    });
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + favoritePuzzles);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        favoriteDataPuzzles = json.decode(jsonFile.readAsStringSync());
        favoriteDataPuzzles =
            favoriteDataPuzzles.map((fav) => RhymesList.fromJson(fav)).toList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: main_bg,
      appBar: appBar,
      body: _selectedIndex == 0
          ? Container(
            child: _pushFavoritesAudioTales(context))
          : _selectedIndex == 1
              ? Container(child: _pushFavoritesMusic(context))
              : _selectedIndex == 2
                  ? Container(child: _pushFavoritesKaraoke(context))
                  : _selectedIndex == 3
                      ? Container(child: _pushFavoritesFilmstrip(context))
                      : _selectedIndex == 4
                          ? Container(child: _pushFavoritesText(context))
                          : Container(child: _pushFavoritesPuzzles(context)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.headset, color: Colors.black),
            title: Text('Аудиосказки'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note, color: Colors.black),
            title: Text('Музыка'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic, color: Colors.black),
            title: Text('Караоке'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_in_picture, color: Colors.black),
            title: Text('Диафильмы'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black),
            title: Text('Тексты'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline, color: Colors.black),
            title: Text('Загадки'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Consumer<AudioPlayerProvider>(
        builder: (ctx, data, ch) => data.show(),
      ),
    );
  }

  Widget _pushFavoritesPuzzles(BuildContext context) {
    if (favoriteDataPuzzles.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: favoriteDataPuzzles.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = favoriteDataPuzzles[index].id;
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            return GestureDetector(
              child: Container(
                height: deviceSize.height * 0.115,
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.5)),
                  margin: EdgeInsets.all(2),
                  color: main_fg,
                  elevation: 5.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: deviceSize.width * 0.3,
                          child: Hero(
                            tag: favoriteDataPuzzles[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: (Platform.isIOS &&
                                      favoriteDataPuzzles[index].iosImage ==
                                          '1')
                                  ? imageUrlDefText
                                  : imageUrlDefText,
                              placeholder: (context, url) => Image.asset(
                                imageUrlDefText,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                imageUrlDefText,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    favoriteDataPuzzles[index].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      // fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: main_text,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    ' ',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.black54,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(0.1),
                                        child: Text(
                                          favoriteDataPuzzles[index].rating,
                                          style: TextStyle(
                                            fontSize: fontSizeCount,
                                            fontStyle: FontStyle.italic,
                                            color: main_text,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new PuzzlesPage(rhymesList: favoriteDataPuzzles[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

  Widget _pushFavoritesKaraoke(BuildContext context) {
    if (favoriteDataKaraoke.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: favoriteDataKaraoke.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            bool checkSave = false;
            var id = favoriteDataKaraoke[index].id;
            var sizeConvert =
                filesize(int.parse(favoriteDataKaraoke[index].cafSize));
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            // void save() {
            //   if (favoriteDataKaraoke != null && favoriteDataKaraoke.length > 0) {
            //     for (int i = 0; i < favoriteDataKaraoke.length; i++) {
            //       var count = File(favoriteDataKaraoke[i]).path.split('/').last;
            //       if (count == '$id.mp3') {
            //         checkSave = true;
            //       } else if (favoriteDataKaraoke.length == i) {
            //         break;
            //       } else
            //         continue;
            //     }
            //   }
            // }

            // save();

            return GestureDetector(
              child: Container(
                height: deviceSize.height * 0.115,
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.5)),
                  margin: EdgeInsets.all(2),
                  color: main_fg,
                  elevation: 5.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: deviceSize.width * 0.3,
                          child: Hero(
                            tag: favoriteDataKaraoke[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Image.asset(
                                imageUrlDefAudio,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                imageUrlDefAudio,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    favoriteDataKaraoke[index].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontStyle: FontStyle.italic,
                                      color: main_text,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    favoriteDataKaraoke[index].author,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSizeDesc,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              favoriteDataKaraoke[index]
                                                  .duration,
                                              style: TextStyle(
                                                fontSize: fontSizeDesc,
                                                fontStyle: FontStyle.italic,
                                                color: main_text,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new KaraokePlayer(
                      karaokeDetailsJSON: favoriteDataKaraoke[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

  Widget _pushFavoritesFilmstrip(BuildContext context) {
    if (favoriteDataFilmstrip.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: favoriteDataFilmstrip.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            bool checkSave = false;
            var id = favoriteDataFilmstrip[index].id;
            var sizeConvert =
                filesize(int.parse(favoriteDataFilmstrip[index].size));
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            // void save() {
            //   if (favoriteDataFilmstrip != null && favoriteDataFilmstrip.length > 0) {
            //     for (int i = 0; i < favoriteDataFilmstrip.length; i++) {
            //       var count = File(favoriteDataFilmstrip[i]).path.split('/').last;
            //       if (count == '$id' + '_m.zip' || count == '$id.zip') {
            //         checkSave = true;
            //       } else if (favoriteDataFilmstrip.length == i) {
            //         break;
            //       } else
            //         continue;
            //     }
            //   }
            // }

            // save();

            return GestureDetector(
              child: Container(
                height: deviceSize.height * 0.115,
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.5)),
                  margin: EdgeInsets.all(2),
                  color: main_fg,
                  elevation: 5.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: deviceSize.width * 0.3,
                          child: Hero(
                            tag: favoriteDataFilmstrip[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Image.asset(
                                imageUrlDefVideo,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                imageUrlDefVideo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    favoriteDataFilmstrip[index].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      // fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: main_text,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    favoriteDataFilmstrip[index].author,
                                    style: TextStyle(
                                      fontSize: fontSizeDesc,
                                      //color: desc_text,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              favoriteDataFilmstrip[index]
                                                  .duration,
                                              style: TextStyle(
                                                fontSize: fontSizeCount,
                                                fontStyle: FontStyle.italic,
                                                color: main_text,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new FilmstripArchive(
                      filmstripDetailsJSON: favoriteDataFilmstrip[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

  Widget _pushFavoritesMusic(BuildContext context) {
    if (favoriteDataMusic.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: favoriteDataMusic.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            bool checkSave = false;
            var id = favoriteDataMusic[index].id;
            var sizeConvert =
                filesize(int.parse(favoriteDataMusic[index].size));
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            // void save() {
            //   if (favoriteDataAudioTale != null && favoriteDataAudioTale.length > 0) {
            //     for (int i = 0; i < favoriteDataAudioTale.length; i++) {
            //       var count = File(favoriteDataAudioTale[i]).path.split('/').last;
            //       if (count == '$id.mp3') {
            //         checkSave = true;
            //       } else if (favoriteDataAudioTale.length == i) {
            //    п     break;
            //       } else
            //         continue;
            //     }
            //   }
            // }

            // save();

            return GestureDetector(
              child: Container(
                height: deviceSize.height * 0.115,
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.5)),
                  margin: EdgeInsets.all(2),
                  color: main_fg,
                  elevation: 5.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: deviceSize.width * 0.3,
                          child: Hero(
                            tag: favoriteDataMusic[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Image.asset(
                                imageUrlDefAudio,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                imageUrlDefAudio,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    favoriteDataMusic[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontStyle: FontStyle.italic,
                                      color: main_text,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " ",
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  favoriteDataMusic[index]
                                                      .duration,
                                                  style: TextStyle(
                                                    fontSize: fontSizeCount,
                                                    fontStyle: FontStyle.italic,
                                                    color: main_text,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Icon(
                                                        Icons.star,
                                                        color: Colors.black54,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      favoriteDataMusic[index]
                                                          .rating,
                                                      style: TextStyle(
                                                        fontSize: fontSizeCount,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: main_text,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(' '),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new MusicPlayer(
                      musicDetailsJSON: favoriteDataMusic[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

//AudioTales
  Widget _pushFavoritesAudioTales(BuildContext context) {
    if (favoriteDataAudioTale.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: favoriteDataAudioTale.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          bool checkSave = false;
          var id = favoriteDataAudioTale[index].id;
          var sizeConvert =
              filesize(int.parse(favoriteDataAudioTale[index].size));
          String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

          void save() {
            if (audioTaleList != null && audioTaleList.length > 0) {
              for (int i = 0; i < audioTaleList.length; i++) {
                var count = File(audioTaleList[i]).path.split('/').last;
                if (count == '$id.mp3') {
                  checkSave = true;
                } else if (audioTaleList.length == i) {
                  break;
                } else
                  continue;
              }
            }
          }

          save();

          return GestureDetector(
            child: Container(
              height: deviceSize.height * 0.115,
              child: Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2.5)),
                margin: EdgeInsets.all(2),
                color: main_fg,
                elevation: 5.0,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        width: deviceSize.width * 0.3,
                        child: Hero(
                          tag: favoriteDataAudioTale[index].id,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageURL,
                            placeholder: (context, url) => Image.asset(
                              imageUrlDefText,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              imageUrlDefText,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  favoriteDataAudioTale[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontStyle: FontStyle.italic,
                                    color: main_text,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  favoriteDataAudioTale[index].author,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                favoriteDataAudioTale[index]
                                                    .duration,
                                                style: TextStyle(
                                                  fontSize: fontSizeCount,
                                                  fontStyle: FontStyle.italic,
                                                  color: main_text,
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.black54,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    favoriteDataAudioTale[index]
                                                        .rating,
                                                    style: TextStyle(
                                                      fontSize: fontSizeCount,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(' '),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new AudioTalePlayer(
                    audioTaleDetailsJSON: favoriteDataAudioTale[index]),
              );
              Navigator.of(context).push(route);
            },
          );
        },
      );
    }
  }

//Texts
  Widget _pushFavoritesText(BuildContext context) {
    if (favoriteDataText.length < 1) {
      return Container(
        child: Center(
          child: Text('Список пуст...'),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: favoriteDataText.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = favoriteDataText[index].id;
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            return GestureDetector(
              child: Container(
                height: deviceSize.height * 0.115,
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2.5)),
                  margin: EdgeInsets.all(2),
                  color: main_fg,
                  elevation: 5.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: deviceSize.width * 0.3,
                          child: Hero(
                            tag: favoriteDataText[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Image.asset(
                                imageUrlDefText,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                imageUrlDefText,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    favoriteDataText[index].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      // fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: main_text,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    ' ',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.black54,
                                          size: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(0.1),
                                        child: Text(
                                          favoriteDataText[index].duration,
                                          style: TextStyle(
                                            fontSize: fontSizeCount,
                                            fontStyle: FontStyle.italic,
                                            color: main_text,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                var route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      TextPage(textDetailsJSON: favoriteDataText[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }
}
