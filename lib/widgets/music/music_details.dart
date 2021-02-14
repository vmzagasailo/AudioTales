import 'dart:io';

import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/widgets/music/player/music_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/resource/api/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';
import '../hints/hints.dart';

class MusicDetails extends StatefulWidget {
  final TaleInf taleInf;

  MusicDetails({Key key, this.taleInf}) : super(key: key);

  @override
  _MusicDetailsState createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  var playerData;
  @override
  void didChangeDependencies() {
    _loadData();
    playerData = Provider.of<AudioPlayerProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    musicList = prefs.getStringList('musicList');

    if (musicList == null) {
      musicList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: true);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: const Text('Музыка'),
      actions: <Widget>[
        IconButton(
          focusColor: Colors.red,
          icon: Icon(Icons.question_answer),
          tooltip: "Советы",
          onPressed: () {
            var route = MaterialPageRoute(
                //! Important currId represents index of BottomNavigationBarItem in Hints.dart
                builder: (BuildContext context) => Hints(currId: 2));
            Navigator.of(context).push(route);
            // Navigator.push(context, route);
          },
        ),
      ],
    );
    return Scaffold(
        backgroundColor: main_bg,
        appBar: appBar,
        body: Container(
          child: FutureBuilder<List<MusicDetailsJSON>>(
              future: talesData.fetchMusicDetails(widget.taleInf.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.error != null) {
                    return Center(
                        child: Text(
                            'Произошла ошибка, проверьте интернет-соединение или перезагрузите страницу'));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        // ignore: missing_return
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.taleInf.id == snapshot.data[index].stId) {
                            var id = snapshot.data[index].id;

                            String imageURL =
                                'https://audiotales.exyte.top/imageItems/$id.png';
                            bool checkSave = false;
                            var sizeConvert =
                                filesize(int.parse(snapshot.data[index].size));

                            void save() {
                              if (musicList != null && musicList.length > 0) {
                                for (int i = 0; i < musicList.length; i++) {
                                  var count =
                                      File(musicList[i]).path.split('/').last;
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
                                              border: Border.all(
                                                  color: Colors.black)),
                                          width: deviceSize.width * 0.3,
                                          child: Hero(
                                            tag: snapshot.data[index].id,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: imageURL,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                imageUrlDefAudio,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                imageUrlDefAudio,
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
                                            padding: EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data[index].name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ' ',
                                                    style: TextStyle(
                                                      fontSize: fontSizeDesc,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .duration,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        fontSizeCount,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color:
                                                                        main_text,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .black54,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .rating,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            fontSizeCount,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                        color:
                                                                            main_text,
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    fontSizeCount,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color:
                                                                    main_text,
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
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MusicPlayer(
                                          musicDetailsJSON:
                                              snapshot.data[index]),
                                );
                                Navigator.of(context).push(route);
                              },
                            );
                          }
                        });
                  }
                }
              }),
        ),
        floatingActionButton: Consumer<AudioPlayerProvider>(
          builder: (ctx, data, ch) => data.show(),
        ),
      
    );
  }
}
