import 'package:audiotales/providers/audioPlayerProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:audiotales/main.dart';
import 'package:provider/provider.dart';
// type 7 - audiotales
// type 4 - music
// type 8 - filmstrip
// type 9 - texts
// type 2 - cartoons
// type 3 - films

class Hints extends StatefulWidget {
  final int currId;
  Hints({this.currId});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState(currId);
  }
}

class _SearchPageState extends State<Hints> {
  final int currId;
  _SearchPageState(this.currId);
  List<List<HintJSON>> allContent = List(10);

  List<SearchJSON> content = new List<SearchJSON>();
  // //audiotales
  List<HintJSON> audioTale = List();
  // //music
  List<HintJSON> musicTale = List();
  // // film
  // List<HintJSON> filmTale = List();
  // // filmstrip
  // List<HintJSON> filmstripTale = List();
  // // cartoon
  // List<HintJSON> cartoonTale = List();
  // // text
  // List<HintJSON> textTale = List();

  // TextEditingController _controller = TextEditingController();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    hintAPI(7).then((audioTaleFromServer) {
      setState(() {
        //search result AudioTales
        allContent[7] = audioTaleFromServer;
      });
    });
    hintAPI(4).then((musicsFromServer) {
      setState(() {
        //search result musics
        allContent[4] = musicsFromServer;
      });
    });
    hintAPI(3).then((filmsFromServer) {
      setState(() {
        //search result films
        allContent[3] = filmsFromServer;
      });
    });
    hintAPI(8).then((filmstripsFromServer) {
      setState(() {
        //search result Filmstrips
        allContent[8] = filmstripsFromServer;
      });
    });
    hintAPI(2).then((cartoonsFromServer) {
      setState(() {
        //search result Cartoons
        allContent[2] = cartoonsFromServer;
      });
    });
    hintAPI(9).then((textsFromServer) {
      setState(() {
        //search result texts
        allContent[9] = textsFromServer;
      });
    });
    if (currId != null) {
      _selectedIndex = currId;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _changeScreen(int index) {
  //   _selectedIndex = index;
  //   switch (_selectedIndex) {
  //     case 0:
  //       hintAPI(7).then((audioTaleFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = audioTaleFromServer;
  //         });
  //       });
  //       break;
  //     case 1:
  //       hintAPI(4).then((musicsFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = musicsFromServer;
  //         });
  //       });
  //       break;
  //     case 2:
  //       hintAPI(3).then((filmsFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = filmsFromServer;
  //         });
  //       });
  //       break;
  //     case 3:
  //       hintAPI(8).then((filmstripsFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = filmstripsFromServer;
  //         });
  //       });
  //       break;
  //     case 4:
  //       hintAPI(2).then((cartoonsFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = cartoonsFromServer;
  //         });
  //       });
  //       break;
  //     default:
  //       hintAPI(9).then((textsFromServer) {
  //         setState(() {
  //           //search result AudioTales
  //           audioTale = textsFromServer;
  //         });
  //       });
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: main_bg,
      drawer: new NavDrawer(),
      appBar: AppBar(
        title: Text("Советы"),
      ),
      body: _selectedIndex == 0
          ? Container(
              child: Container(child: _pushItem(7)),
            )
          : (_selectedIndex == 1
              ? Container(child: Container(child: _pushItem(4)))
              : _selectedIndex == 2
                  ? Container(child: Container(child: _pushItem(3)))
                  : _selectedIndex == 3
                      ? Container(child: Container(child: _pushItem(8)))
                      : _selectedIndex == 4
                          ? Container(child: Container(child: _pushItem(2)))
                          : Container(child: Container(child: _pushItem(9)))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.headset,
                color: Colors.black,
              ),
              title: Text('Аудиосказки')),
          BottomNavigationBarItem(
              icon: Icon(Icons.book, color: Colors.black),
              title: Text('Тексты')),
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

  Widget _pushItem(int id) {
    return new FutureBuilder<List<HintJSON>>(
        future: hintAPI(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                  // var id = searchTextTale[index].id;
                  // String imageURL = 'https://audiotales.exyte.top/imageItems/$id.png';
                  return Column(
                    children: <Widget>[
                      ListTile(
                          title: new Card(
                            color: main_fg,
                            elevation: 1.0,
                            child: new Container(
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  // CachedNetworkImage(
                                  //   imageUrl: imageURL,
                                  //   height: imageItems,
                                  //   width: imageItems,
                                  //   placeholder: (context, url) =>
                                  //       new CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) =>
                                  //       new Image.asset(
                                  //     imageUrlDefText,
                                  //     width: imageItems,
                                  //     height: imageItems,
                                  //   ), //// YOU CAN CREATE YOUR OWN ERROR WIDGET HERE
                                  // ),
                                  Row(children: <Widget>[
                                    Flexible(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Wrap(
                                            children: <Widget>[
                                              Padding(
                                                  child: Text(
                                                    snapshot.data[index].header,
                                                    style: (TextStyle(
                                                      fontSize: fontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
                                                    )),
                                                  ),
                                                  padding: EdgeInsets.all(1.0)),
                                              Padding(
                                                  child: Text(
                                                    snapshot.data[index].text,
                                                    style: (TextStyle(
                                                      fontSize: fontSize,
                                                      color: main_text,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    )),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 5.0)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            switch (id) {
                              case 2:
                                Navigator.pushNamed(context, '/cartoons');
                                break;
                              case 3:
                                Navigator.pushNamed(context, '/films');
                                break;
                              case 4:
                                Navigator.pushNamed(context, '/music');
                                break;
                              case 7:
                                Navigator.pushNamed(context, '/audioTale');
                                break;
                              case 8:
                                Navigator.pushNamed(context, '/filmstrips');
                                break;
                              case 9:
                                Navigator.pushNamed(context, '/texts');
                                break;
                              default:
                                break;
                            }
                          }),
                    ],
                  );
                });
          }
        });
  }
}

Widget _pushSearchMusic() {}

Widget _pushSearchText() {}

Widget _pushSearchFilmstrip() {}

Widget _pushSearchCartoons() {}

Widget _pushSearchFilms() {}
