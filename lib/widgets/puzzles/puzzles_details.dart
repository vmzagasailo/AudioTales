import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:audiotales/widgets/puzzles/puzzles_page.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../providers/talesProvider.dart';
import '../../providers/audioPlayerProvider.dart';

class PuzzlesDetails extends StatefulWidget {
  final RhymesList rhymesList;
  final TextDetailsJSON textDetailsJSON;

  PuzzlesDetails({Key key, this.rhymesList, this.textDetailsJSON})
      : super(key: key);

  @override
  _PuzzlesDetailsState createState() => _PuzzlesDetailsState();
}

class _PuzzlesDetailsState extends State<PuzzlesDetails> {
  @override
  Widget build(BuildContext context) {
    final talesData = Provider.of<TalesProvider>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: Text(widget.rhymesList.name),
    );
    return Scaffold(
        backgroundColor: main_bg,
        appBar: appBar,
        body: Container(
          child: FutureBuilder<List<RhymesList>>(
              future: talesData.fetchPuzzlesDetails(widget.rhymesList.id),
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
                                            BorderRadius.circular(2.5)),
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
                                                imageUrl: (Platform.isIOS &&
                                                        snapshot.data[index]
                                                                .iosImage ==
                                                            '1')
                                                    ? imageUrlDefText
                                                    : imageUrlDefText,
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
                                        PuzzlesPage(
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
