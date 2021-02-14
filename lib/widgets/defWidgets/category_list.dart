import 'package:audiotales/widgets/karaoke/karaoke_details.dart';
import 'package:audiotales/widgets/puzzles/puzzles_details.dart';
import 'package:audiotales/widgets/rhymes/rhymes_details.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/globalData.dart';

import 'package:audiotales/widgets/cartoons/cartoon_details.dart';
import 'package:audiotales/widgets/films/film_details.dart';
import 'package:audiotales/widgets/music/music_details.dart';
import 'package:audiotales/widgets/audioTales/audio_tale_details.dart';
import 'package:audiotales/widgets/filmstrips/filmstrip_details.dart';
import 'package:audiotales/widgets/texts/text_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatergoryList extends StatelessWidget {
  final int category;
  final data;

  CatergoryList({Key key, this.data, this.category}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: data.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          var id = data[index].id;
          String imageURL = 'https://data.audiobb.ru/files/sets/s$id.jpg';
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
                            tag: data[index].id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: imageURL,
                              placeholder: (context, url) => Image.asset(
                                category == 1
                                    ? imageUrlDefText
                                    : category == 2
                                        ? imageUrlDefAudio
                                        : category == 3
                                            ? imageUrlDefAudio
                                            : category == 4
                                                ? imageUrlDefVideo
                                                : category == 5
                                                    ? imageUrlDefVideo
                                                    : category == 6
                                                        ? imageUrlDefVideo
                                                        : category == 7
                                                            ? imageUrlDefText
                                                            : category == 8
                                                                ? imageUrlDefText
                                                                : imageUrlDefText,
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
                                    data[index].name,
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
                                    data[index].desc,
                                    style: TextStyle(
                                      fontSize: fontSizeDesc,
                                      //color: desc_text,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data[index].count,
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
                switch (category) {
                  case 1:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AudioTaleDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 2:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MusicDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 3:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          KaraokeDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 4:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FilmstripDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 5:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CartoonDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 6:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FilmDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 7:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TextDetails(taleInf: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 8:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RhymesDetails(rhymesList: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                  case 9:
                    var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PuzzlesDetails(rhymesList: data[index]),
                    );
                    Navigator.of(context).push(route);
                    break;
                }
              });
        });
  }
}
