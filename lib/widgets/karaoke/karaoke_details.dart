import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:filesize/filesize.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audiotales/modelJSON/admob.dart';
import 'package:flutter/services.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/widgets/karaoke/karaoke_player.dart';
import 'package:audiotales/widgets/defWidgets/def_list_img.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';

const String testDevice = 'F9DFBA416DCF6AA55E05AC814CBB527C';

class KaraokeDetails extends StatefulWidget {
  final TaleInf taleInf;
  final AudioTaleDetailsJSON audioTaleDetailsJSON;
  String checkId;

  KaraokeDetails({Key key, this.taleInf, this.audioTaleDetailsJSON})
      : super(key: key);

  @override
  _AudioTaleDetailsState createState() => _AudioTaleDetailsState();
}

class _AudioTaleDetailsState extends State<KaraokeDetails> {
  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    audioTaleList = prefs.getStringList('audioTaleList');
    if (audioTaleList == null) {
      audioTaleList = [];
    }
  }
  // new FutureBuilder<List<AudioTaleDetailsJSON>>(
  //             future: audioTaleDetailsAPI(),

  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: const Text('Караоке'),
    );
    return Scaffold(
        backgroundColor: main_bg,
        appBar: appBar,
        body: Container(
          child: FutureBuilder<List<KaraokeDetailsJSON>>(
              future: talesData.fetchKaraokeDetails(widget.taleInf.id),
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
                          if (widget.taleInf.id == widget.taleInf.id) {
                            bool checkSave = false;
                            var id = snapshot.data[index].id;
                            String imageURL =
                                'https://data.audiobb.ru/files/img/$id.jpg';
                            var sizeConvert = filesize(
                                int.parse(snapshot.data[index].cafSize));

                            void save() {
                              if (audioTaleList != null &&
                                  audioTaleList.length > 0) {
                                for (int i = 0; i < audioTaleList.length; i++) {
                                  var count = File(audioTaleList[i])
                                      .path
                                      .split('/')
                                      .last;
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
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: main_text,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data[index].author,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .duration,
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
                                      KaraokePlayer(
                                          karaokeDetailsJSON:
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
