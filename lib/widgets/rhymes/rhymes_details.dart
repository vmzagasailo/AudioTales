import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/resource/api/api.dart';
import 'package:audiotales/widgets/rhymes/rhymes_page.dart';
import 'dart:io';
import '../hints/hints.dart';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';

class RhymesDetails extends StatefulWidget {
  final RhymesList rhymesList;
  final TextDetailsJSON textDetailsJSON;

  RhymesDetails({Key key, this.rhymesList, this.textDetailsJSON})
      : super(key: key);

  @override
  _RhymesDetailsState createState() => _RhymesDetailsState();
}

class _RhymesDetailsState extends State<RhymesDetails> {
  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = new AppBar(
      title: new Text('Потешки'),
      actions: <Widget>[
        IconButton(
          focusColor: Colors.red,
          icon: Icon(Icons.question_answer),
          tooltip: "Советы",
          onPressed: () {
            var route = new MaterialPageRoute(
                //! Important currId represents index of BottomNavigationBarItem in Hints.dart
                builder: (BuildContext context) => Hints(currId: 1));
            Navigator.of(context).push(route);
            // Navigator.push(context, route);
          },
        ),
      ],
    );
    return  Scaffold(
        backgroundColor: main_bg,
        appBar: appBar,
        body: Container(
          child: new FutureBuilder<List<RhymesList>>(
              future: talesData.fetchRhymesDetails(widget.rhymesList.id),
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
                          if (widget.rhymesList.id ==
                              snapshot.data[index].set_id) {
                            return GestureDetector(
                                child: Container(
                                  height: deviceSize.height * 0.115,
                                  child: Card(
                                    shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.5)),
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
                                                imageUrl: imageUrlDefText,
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
                                              padding:
                                                  EdgeInsets.only(left: 4.0),
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
                                                      ' ',
                                                      style: TextStyle(
                                                        fontSize: fontSizeDesc,
                                                        //color: desc_text,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.black54,
                                                            size: 18,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.1),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .rating,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontSizeCount,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: main_text,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                        RhymesPage(
                                            rhymesList: snapshot.data[index]),
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
