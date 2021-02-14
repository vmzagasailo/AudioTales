import 'package:audiotales/widgets/texts/text_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:provider/provider.dart';
import '../../providers/audioPlayerProvider.dart';

class TextDetails extends StatefulWidget {
  final TaleInf taleInf;

  TextDetails({Key key, this.taleInf}) : super(key: key);

  @override
  _TextDetailsState createState() => _TextDetailsState();
}

class _TextDetailsState extends State<TextDetails> {
  Icon ratingIcon = Icon(
    Icons.star,
    color: Colors.black,
  );
  Future<List<TextDetailsJSON>> textDetailsAPI() async {
    var id = widget.taleInf.id;
    var response =
        await http.get('https://audiotales.exyte.top/JSON/9/$id.json');

    if (response.statusCode == 200) {
      List textDetailsURL = json.decode(utf8.decode(response.bodyBytes));
      return textDetailsURL
          .map((textDetailsURL) => new TextDetailsJSON.fromJson(textDetailsURL))
          .toList();
    } else
      throw Exception('fail in load data');
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var appBar = AppBar(
      title: Text('Тексты'),
    );
    return Scaffold(
        backgroundColor: main_bg,
        appBar: appBar,
        body: Container(
          child: FutureBuilder<List<TextDetailsJSON>>(
              //future: myTextsDetailsAPI(widget.taleInf.id),
              future: textDetailsAPI(),
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
                                                      softWrap: false,
                                                      maxLines: 1,
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
                                                      snapshot
                                                          .data[index].author,
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
                                                                style:
                                                                    TextStyle(
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
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    child: Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .black54,
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .popularity,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        TextStyle(
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
                                                                ],
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
                                    builder: (BuildContext context) => TextPage(
                                        textDetailsJSON: snapshot.data[index]),
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
