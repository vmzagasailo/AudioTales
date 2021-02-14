import 'dart:async';

import 'package:audiotales/modelJSON/admob.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartoonsPage extends StatefulWidget {
  final CartoonDetailsJSON cartoonDetailsJSON;

  CartoonsPage({Key key, this.cartoonDetailsJSON}) : super(key: key);
  @override
  _CartoonsPageState createState() => _CartoonsPageState();
}

class _CartoonsPageState extends State<CartoonsPage> {
  InterstitialAd _interstitialAd;

  Future<bool> _onWillPop() async {
    myInterstitial();
  }

  InterstitialAd myInterstitial() {
    _interstitialAd = InterstitialAd(
        adUnitId: getInterstitialAdUnitId(),
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _interstitialAd.show(anchorType: AnchorType.bottom);
          }
          if (event == MobileAdEvent.opened ||
              event == MobileAdEvent.clicked ||
              event == MobileAdEvent.failedToLoad) {
            Navigator.of(context).pop(true);
          }
        })
      ..load();
  }

  void playYoutubeVideoIdEditAuto() {
    FlutterYoutube.onVideoEnded.listen((onData) {});
    FlutterYoutube.playYoutubeVideoById(
        apiKey: "<API_KEY>",
        videoId: widget.cartoonDetailsJSON.url,
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    String imageURL =
        'https://audiotales.exyte.top/imageItems/${widget.cartoonDetailsJSON.id}.png';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: main_bg,
          appBar: AppBar(
            title: Text(widget.cartoonDetailsJSON.name),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            playYoutubeVideoIdEditAuto();
                          }),
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
                            widget.cartoonDetailsJSON.popularity,
                            style: TextStyle(
                              fontSize: fontSizeCount,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: FlutterYoutube.playYoutubeVideoById(
                      apiKey: "<API_KEY>",
                      videoId: widget.cartoonDetailsJSON.url,
                      autoPlay: true),
                ),
              ],
            ),
          )),
    );
  }
}
