import 'dart:io';

import 'package:audiotales/resource/api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/widgets/filmstrips/filmsrtrip_archive.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import '../hints/hints.dart';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';

class FilmstripDetails extends StatefulWidget {
  final TaleInf taleInf;

  FilmstripDetails({Key key, this.taleInf}) : super(key: key);

  @override
  _FilmstripDetailsState createState() => _FilmstripDetailsState();
}

class _FilmstripDetailsState extends State<FilmstripDetails> {
  // Future<List<FilmstripDetailsJSON>> filmstripDetailsAPI() async {
  //   var id = widget.taleInf.id;
  //   var response =
  //       await http.get('https://audiotales.exyte.top/JSON/8/$id.json');

  //   if (response.statusCode == 200) {
  //     List filmstripDetailsURL = json.decode(utf8.decode(response.bodyBytes));
  //     return filmstripDetailsURL
  //         .map((textDetailsURL) =>
  //             new FilmstripDetailsJSON.fromJson(textDetailsURL))
  //         .toList();
  //   } else
  //     throw Exception('fail in load data');
  // }

  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: const Text('Диафильмы'),
      actions: <Widget>[
        IconButton(
          focusColor: Colors.red,
          icon: Icon(Icons.question_answer),
          tooltip: "Советы",
          onPressed: () {
            var route = MaterialPageRoute(
                //! Important currId represents index of BottomNavigationBarItem in Hints.dart
                builder: (BuildContext context) => Hints(currId: 3));
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
        child: FutureBuilder<List<FilmstripDetailsJSON>>(
            future: talesData.fetchFilmstripsDetails(widget.taleInf.id),
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
                          var sizeConvert =
                              filesize(int.parse(snapshot.data[index].size));
                          bool checkSave = false;

                          void save() {
                            if (filmstripList != null &&
                                filmstripList.length > 0) {
                              for (int i = 0; i < filmstripList.length; i++) {
                                var count =
                                    File(filmstripList[i]).path.split('/').last;
                                if (count == '$id' + '_m.zip' ||
                                    count == '$id.zip') {
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
                                                imageUrlDefVideo,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                      // fontWeight: FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data[index].author,
                                                    style: TextStyle(
                                                      fontSize: fontSizeDesc,
                                                      //color: desc_text,
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
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .duration,
                                                              style: TextStyle(
                                                                //fontWeight: FontWeight.bold,
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
                                                                //fontWeight: FontWeight.bold,
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
                                      FilmstripArchive(
                                          filmstripDetailsJSON:
                                              snapshot.data[index]),
                                );
                                Navigator.of(context).push(route);
                              });
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
