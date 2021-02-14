import 'package:audiotales/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';
import '../hints/hints.dart';
import 'rhymes_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Rhymes extends StatelessWidget {
  final int category = 8;
  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: Text('Потешки'),
      actions: <Widget>[
        IconButton(
          focusColor: Colors.red,
          icon: Icon(Icons.question_answer),
          tooltip: "Советы",
          onPressed: () {
            var route = MaterialPageRoute(
                //! Important currId represents index of BottomNavigationBarItem in Hints.dart
                builder: (BuildContext context) => Hints(currId: 1));
            Navigator.of(context).push(route);
            // Navigator.push(context, route);
          },
        ),
      ],
    );
    return Scaffold(
        backgroundColor: main_bg,
        drawer: NavDrawer(),
        appBar: appBar,
        body: Container(
          padding: EdgeInsets.all(0.0),
          child: FutureBuilder<List<RhymesList>>(
            future: talesData.fetchRhymesList(1),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return Center(
                    child: Container(
                      height: (deviceSize.height -
                              (appBar.preferredSize.height +
                                  bannerAd.size.height)) *
                          0.35,
                      width: deviceSize.width * 0.8,
                      child: Card(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        margin: EdgeInsets.all(2),
                        color: main_fg,
                        elevation: 5.0,
                        child: Container(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Произошла ошибка',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Проверьте интернет-соединение или перезагрузите страницу',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Divider(color: Colors.black),
                                    Container(
                                      child: FlatButton(
                                        child: Text('Перезагрузить'),
                                        color: Colors.blueAccent,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          var route = MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Rhymes(),
                                          );
                                          Navigator.of(context).push(route);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      // ignore: missing_return
                      itemBuilder: (BuildContext context, int index) {
                        var id = snapshot.data[index].id;
                        String imageURL =
                            'https://audiotales.exyte.top/imageSets/s$id.png';

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
                                              imageUrlDefText,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
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
                                                  snapshot.data[index].desc,
                                                  style: TextStyle(
                                                    fontSize: fontSizeDesc,
                                                    //color: desc_text,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data[index].count,
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
                              var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RhymesDetails(
                                        rhymesList: snapshot.data[index]),
                              );
                              Navigator.of(context).push(route);
                            });
                      });

                  // CatergoryList(
                  //   data: snapshot.data,
                  //   category: category,
                  // );
                }
              }
            },
          ),
        ),
        floatingActionButton: Consumer<AudioPlayerProvider>(
          builder: (ctx, data, ch) => data.show(),
        ),
      
    );
  }
}
