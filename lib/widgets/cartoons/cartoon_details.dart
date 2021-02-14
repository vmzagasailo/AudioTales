import 'dart:io';

import 'package:audiotales/modelJSON/admob.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';

import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:audiotales/modelJSON/globalData.dart';

import '../hints/hints.dart';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';
import 'cartoon_page.dart';

class CartoonDetails extends StatefulWidget {
  final TaleInf taleInf;

  CartoonDetails({Key key, this.taleInf}) : super(key: key);

  @override
  _CartoonDetailsState createState() => _CartoonDetailsState();
}

class _CartoonDetailsState extends State<CartoonDetails> {
  InterstitialAd _interstitialAd;
  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: const Text('Мультики'),
      actions: <Widget>[
        IconButton(
          focusColor: Colors.red,
          icon: Icon(Icons.question_answer),
          tooltip: "Советы",
          onPressed: () {
            var route = new MaterialPageRoute(
                //! Important currId represents index of BottomNavigationBarItem in Hints.dart
                builder: (BuildContext context) => Hints(currId: 4));
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
        child: new FutureBuilder<List<CartoonDetailsJSON>>(
            future: talesData.fetchCartoonsDetails(widget.taleInf.id),
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
                          String imageURL =
                              'https://audiotales.exyte.top/imageItems/${snapshot.data[index].id}.png';

                          InterstitialAd myInterstitial() {
                            _interstitialAd = InterstitialAd(
                                adUnitId: getInterstitialAdUnitId(),
                                targetingInfo: targetingInfo,
                                listener: (MobileAdEvent event) {
                                  if (event == MobileAdEvent.loaded) {
                                    _interstitialAd.show(
                                        anchorType: AnchorType.bottom);
                                  }
                                  if (event == MobileAdEvent.opened ||
                                      event == MobileAdEvent.failedToLoad) {
                                    //load youtubePlayer
                                    void playYoutubeVideoIdEditAuto() {
                                      FlutterYoutube.onVideoEnded
                                          .listen((onData) {});
                                      FlutterYoutube.playYoutubeVideoById(
                                          apiKey: "<API_KEY>",
                                          videoId: snapshot.data[index].url,
                                          autoPlay: true);
                                    }

                                    return playYoutubeVideoIdEditAuto();
                                  }
                                })
                              ..load();
                          }

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
                                          padding: EdgeInsets.only(left: 4.0),
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
                                                    fontStyle: FontStyle.italic,
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
                                                    fontSize: fontSize,
                                                    // fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    color: main_text,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data[index].duration,
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
                              if (Platform.isIOS) {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CartoonsPage(
                                          cartoonDetailsJSON:
                                              snapshot.data[index]),
                                );
                                Navigator.of(context).push(route);
                              } else if (Platform.isAndroid) {
                                myInterstitial();
                              }
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
