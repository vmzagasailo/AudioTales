import 'dart:io';

import 'package:audiotales/widgets/audioTales/player/audio_tales_player.dart';
import 'package:audiotales/widgets/music/player/music_player.dart';
import 'package:audiotales/widgets/texts/text_page.dart';
import '../filmstrips/filmsrtrip_archive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:audiotales/modelJSON/globalData.dart';

import 'package:audiotales/resource/api/searchAPI.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../providers/audioPlayerProvider.dart';


// type 7 - audiotales
// type 4 - music
// type 8 - filmstrip
// type 9 - texts
// type 2 - cartoons
// type 3 - films

class SearchPage extends StatefulWidget {
  final String url;

  SearchPage({this.url});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState(url);
  }
}

class _SearchPageState extends State<SearchPage> {
  String url;
  _SearchPageState(this.url);
  List<SearchJSON> content = new List<SearchJSON>();
  //search audiotales
  List<AudioTaleDetailsJSON> audioTale = List();
  List<AudioTaleDetailsJSON> searchTale = List();
  //search music
  List<MusicDetailsJSON> musicTale = List();
  List<MusicDetailsJSON> searchMusicTale = List();
  //search film
  List<FilmDetailsJSON> filmTale = List();
  List<FilmDetailsJSON> searchFilmTale = List();
  //search filmstrip
  List<FilmstripDetailsJSON> filmstripTale = List();
  List<FilmstripDetailsJSON> searchFilmstripTale = List();
  //search cartoon
  List<CartoonDetailsJSON> cartoonTale = List();
  List<CartoonDetailsJSON> searchCartoonTale = List();
  //search text
  List<TextDetailsJSON> textTale = List();
  List<TextDetailsJSON> searchTextTale = List();

  TextEditingController _controller = TextEditingController();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SearchAPI.searchAudioTaleDetailsAPI().then((audioTaleFromServer) {
      setState(() {
        //search result AudioTales
        audioTale = audioTaleFromServer;
        searchTale = audioTale;
      });
    });
    SearchAPI.searchMusicDetailsAPI().then((musicsFromServer) {
      setState(() {
        //search result musics
        musicTale = musicsFromServer;
        searchMusicTale = musicTale;
      });
    });
    SearchAPI.searchFilmDetailsAPI().then((filmsFromServer) {
      setState(() {
        //search result films
        filmTale = filmsFromServer;
        searchFilmTale = filmTale;
      });
    });
    SearchAPI.searchFilmstripDetailsAPI().then((filmstripsFromServer) {
      setState(() {
        //search result Filmstrips
        filmstripTale = filmstripsFromServer;
        searchFilmstripTale = filmstripTale;
      });
    });
    SearchAPI.searchCartoonDetailsAPI().then((cartoonsFromServer) {
      setState(() {
        //search result Cartoons
        cartoonTale = cartoonsFromServer;
        searchCartoonTale = cartoonTale;
      });
    });
    SearchAPI.searchTextDetailsAPI().then((textsFromServer) {
      setState(() {
        //search result texts
        textTale = textsFromServer;
        searchTextTale = textTale;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var deviceSize;
  @override
  Widget build(BuildContext context) {
    bool check = true;
    deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: main_bg,
      appBar: AppBar(
        title: TextFormField(
          onChanged: (String string) {
            setState(() {
              if (string.length >= 3 && check == true) {
                if (_selectedIndex == 0) {
                  searchTale = audioTale
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.author
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                } else if (_selectedIndex == 1) {
                  searchMusicTale = musicTale
                      .where((u) =>
                          (u.name.toLowerCase().contains(string.toLowerCase())))
                      .toList();
                } else if (_selectedIndex == 2) {
                  searchFilmstripTale = filmstripTale
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.author
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                } else if (_selectedIndex == 3) {
                  searchCartoonTale = cartoonTale
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.author
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                } else if (_selectedIndex == 4) {
                  searchFilmTale = filmTale
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.author
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                } else {
                  searchTextTale = textTale
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.author
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                }
              }
            });
          },
          style: Theme.of(context).textTheme.subtitle,
          controller: _controller,
          enableInteractiveSelection: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: "Введите название или автора",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                _controller.clear();
                Fluttertoast.showToast(
                    msg: "Идет загрузка данных",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black45,
                    textColor: Colors.white,
                    fontSize: fontSize);
                if (_selectedIndex == 0) {
                  SearchAPI.searchAudioTaleDetailsAPI()
                      .then((audioTaleFromServer) {
                    setState(() {
                      //search result AudioTales
                      audioTale = audioTaleFromServer;
                      searchTale = audioTale;
                    });
                  });
                } else if (_selectedIndex == 1) {
                  SearchAPI.searchMusicDetailsAPI().then((musicsFromServer) {
                    setState(() {
                      //search result musics
                      musicTale = musicsFromServer;
                      searchMusicTale = musicTale;
                    });
                  });
                } else if (_selectedIndex == 2) {
                  SearchAPI.searchFilmstripDetailsAPI()
                      .then((filmstripsFromServer) {
                    setState(() {
                      //search result Filmstrips
                      filmstripTale = filmstripsFromServer;
                      searchFilmstripTale = filmstripTale;
                    });
                  });
                } else if (_selectedIndex == 3) {
                  SearchAPI.searchCartoonDetailsAPI()
                      .then((cartoonsFromServer) {
                    setState(() {
                      //search result Cartoons
                      cartoonTale = cartoonsFromServer;
                      searchCartoonTale = cartoonTale;
                    });
                  });
                } else if (_selectedIndex == 4) {
                  SearchAPI.searchCartoonDetailsAPI()
                      .then((cartoonsFromServer) {
                    setState(() {
                      //search result Cartoons
                      cartoonTale = cartoonsFromServer;
                      searchCartoonTale = cartoonTale;
                    });
                  });
                } else {
                  SearchAPI.searchFilmDetailsAPI().then((filmsFromServer) {
                    setState(() {
                      //search result films
                      filmTale = filmsFromServer;
                      searchFilmTale = filmTale;
                    });
                  });
                }
              },
            ),
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? Container(child: Container(child: _pushSearchAudioTale()))
          : (_selectedIndex == 1
              ? Container(child: Container(child: _pushSearchMusic()))
              : _selectedIndex == 2
                  ? Container(child: Container(child: _pushSearchFilmstrip()))
                  : _selectedIndex == 3
                      ? Container(
                          child: Container(child: _pushSearchCartoons()))
                      : _selectedIndex == 4
                          ? Container(
                              child: Container(child: _pushSearchFilms()))
                          : Container(
                              child: Container(child: _pushSearchText()))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.headset, color: Colors.black),
              title: Text('Аудиосказки')),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note, color: Colors.black),
              title: Text('Музыка')),
          BottomNavigationBarItem(
              icon: Icon(Icons.picture_in_picture, color: Colors.black),
              title: Text('Диафильмы')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies, color: Colors.black),
              title: Text('Мультфильмы')),
          BottomNavigationBarItem(
              icon: Icon(Icons.videocam, color: Colors.black),
              title: Text('Фильмы')),
          BottomNavigationBarItem(
              icon: Icon(Icons.book, color: Colors.black),
              title: Text('Тексты')),
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

//+
  Widget _pushSearchText() {
    if (searchTextTale.length <= 0) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: searchTextTale == null ? 0 : searchTextTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchTextTale[index].id;
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
                              tag: searchTextTale[index].id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageURL,
                                placeholder: (context, url) => Image.asset(
                                  imageUrlDefText,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                                      searchTextTale[index].name,
                                      softWrap: false,
                                      maxLines: 1,
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
                                      searchTextTale[index].author,
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
                                                searchTextTale[index].duration,
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: fontSizeCount,
                                                  fontStyle: FontStyle.italic,
                                                  color: main_text,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.black54,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    searchTextTale[index]
                                                        .popularity,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      //fontWeight: FontWeight.bold,
                                                      fontSize: fontSizeCount,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
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
                        new TextPage(textDetailsJSON: searchTextTale[index]),
                  );
                  Navigator.of(context).push(route);
                });
          });
    }
  }

//+
  Widget _pushSearchMusic() {
    if (searchMusicTale.length <= 0) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
          itemCount: searchMusicTale == null ? 0 : searchMusicTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchMusicTale[index].id;
            var sizeConvert = filesize(int.parse(searchMusicTale[index].size));
            bool checkSave = false;
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';

            void save() {
              if (musicList != null && musicList.length > 0) {
                for (int i = 0; i < musicList.length; i++) {
                  var count = File(musicList[i]).path.split('/').last;
                  if (count == '$id.mp3') {
                    checkSave = true;
                  } else if (musicList.length == i) {
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
                            tag: searchMusicTale[index].id,
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
                                    searchMusicTale[index].name,
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  searchMusicTale[index].duration,
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
                                                      searchMusicTale[index].rating,
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
                                          child: Container(
                                            child: Text(
                                              checkSave == false
                                                  ? sizeConvert
                                                  : 'сохранено',
                                              textAlign: TextAlign.right,
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
                  builder: (BuildContext context) =>
                      new MusicPlayer(musicDetailsJSON: searchMusicTale[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

//+
  Widget _pushSearchAudioTale() {
    if (searchTale.length <= 0) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
          itemCount: searchTale == null ? 0 : searchTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchTale[index].id;
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';
            bool checkSave = false;
            var sizeConvert = filesize(int.parse(searchTale[index].size));

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
                            tag: searchTale[index].id,
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
                        //width: deviceSize.width * 0.687,
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    searchTale[index].name,
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
                                    searchTale[index].author,
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  searchTale[index].duration,
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
                                                      searchTale[index].rating,
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
                                          child: Container(
                                            child: Text(
                                              checkSave == false
                                                  ? sizeConvert
                                                  : 'сохранено',
                                              textAlign: TextAlign.right,
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
                  builder: (BuildContext context) => new AudioTalePlayer(
                      audioTaleDetailsJSON: searchTale[index]),
                );
                Navigator.of(context).push(route);
              },
            );
          });
    }
  }

//+
  Widget _pushSearchFilmstrip() {
    if (searchFilmstripTale.length <= 0) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
          itemCount:
              searchFilmstripTale == null ? 0 : searchFilmstripTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchFilmstripTale[index].id;
            String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';
            var sizeConvert =
                filesize(int.parse(searchFilmstripTale[index].size));
            bool checkSave = false;

            void save() {
              if (filmstripList != null && filmstripList.length > 0) {
                for (int i = 0; i < filmstripList.length; i++) {
                  var count = File(filmstripList[i]).path.split('/').last;
                  if (count == '$id.mp3') {
                    checkSave = true;
                  } else if (filmstripList.length == i) {
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
                              tag: searchFilmstripTale[index].id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageURL,
                                placeholder: (context, url) => Image.asset(
                                  imageUrlDefVideo,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                                      searchFilmstripTale[index].name,
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
                                      searchFilmstripTale[index].author,
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
                                                searchFilmstripTale[index]
                                                    .duration,
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: fontSizeCount,
                                                  fontStyle: FontStyle.italic,
                                                  color: main_text,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                checkSave == false
                                                    ? sizeConvert
                                                    : 'сохранено',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
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
                        filmstripDetailsJSON: searchFilmstripTale[index]),
                  );
                  Navigator.of(context).push(route);
                });
          });
    }
  }

//+
  Widget _pushSearchCartoons() {
    if (searchCartoonTale.length <= 0) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
          itemCount: searchCartoonTale == null ? 0 : searchCartoonTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchCartoonTale[index].id;
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
                              tag: searchCartoonTale[index].id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageURL,
                                placeholder: (context, url) => Image.asset(
                                  imageUrlDefVideo,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                              padding: EdgeInsets.only(left: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      searchCartoonTale[index].name,
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
                                      searchCartoonTale[index].author,
                                      style: TextStyle(
                                        fontSize: fontSizeDesc,
                                        //color: desc_text,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      searchCartoonTale[index].duration,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  void playYoutubeVideoIdEditAuto() {
                    FlutterYoutube.onVideoEnded.listen((onData) {});
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: "<API_KEY>",
                        videoId: searchCartoonTale[index].url,
                        autoPlay: true);
                  }

                  return playYoutubeVideoIdEditAuto();
                });
          });
    }
  }

//+
  Widget _pushSearchFilms() {
    if (searchFilmTale.length <= 0) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return ListView.builder(
          itemCount: searchFilmTale == null ? 0 : searchFilmTale.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            var id = searchFilmTale[index].id;
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
                              tag: searchFilmTale[index].id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageURL,
                                placeholder: (context, url) => Image.asset(
                                  imageUrlDefVideo,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                              padding: EdgeInsets.only(left: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      searchFilmTale[index].name,
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
                                      searchFilmTale[index].author,
                                      style: TextStyle(
                                        fontSize: fontSizeDesc,
                                        //color: desc_text,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      searchFilmTale[index].duration,
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: fontSizeCount,
                                        fontStyle: FontStyle.italic,
                                        color: main_text,
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
                  void playYoutubeVideoIdEditAuto() {
                    FlutterYoutube.onVideoEnded.listen((onData) {});
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: "<API_KEY>",
                        videoId: searchFilmTale[index].url,
                        autoPlay: true);
                  }

                  return playYoutubeVideoIdEditAuto();
                });
          });
    }
  }
}
