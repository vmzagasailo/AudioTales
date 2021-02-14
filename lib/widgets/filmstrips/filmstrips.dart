import 'package:audiotales/main.dart';
import 'package:audiotales/widgets/defWidgets/category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/widgets/hints/hints.dart';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';

class Filmstrips extends StatelessWidget {
  final int category = 4;
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
        drawer: NavDrawer(),
        appBar: appBar,
        body: Container(
          padding: EdgeInsets.all(0.0),
          child: FutureBuilder<List<TaleInf>>(
              future: talesData.fetchFilmstripsList(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  Filmstrips(),
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

                    // Center(
                    //   child: Text(
                    //       'Произошла ошибка, проверьте интернет-соединение или перезагрузите страницу'),
                    // );
                  } else {
                    return CatergoryList(
                      data: snapshot.data,
                      category: category,
                    );
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
