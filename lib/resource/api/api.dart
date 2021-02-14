import 'dart:async';
import 'dart:io';
import 'package:audiotales/modelJSON/globalData.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:audiotales/modelJSON/taleInf.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../../models/http_exeption.dart';

final Map<String, String> _headers_details = {
  Headers.contentLengthHeader: "100",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.4.38",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_search = {
  Headers.contentLengthHeader: "148",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
};
final Map<String, String> _headers_hint = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
};
final Map<String, String> _headers_karaoke = {
  Headers.contentLengthHeader: "87",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m1.audiobaby.net",
  HttpHeaders.acceptHeader: "*/*",
  HttpHeaders.acceptEncodingHeader: "gzip"
};
final Map<String, String> _headers_karaoke_more = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m1.audiobaby.net",
  HttpHeaders.acceptHeader: "*/*"
};
final Map<String, String> _headers_films = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_films_more = {
  Headers.contentLengthHeader: "100",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_cartoons = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.dateHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_cartoons_more = {
  Headers.contentLengthHeader: "100",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_filmstrips = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_filmstrips_more = {
  Headers.contentLengthHeader: "100",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_music = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_music_more = {
  Headers.contentLengthHeader: "99",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_texts = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_texts_more = {
  Headers.contentLengthHeader: "101",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};
final Map<String, String> _headers_audoitales = {
  Headers.contentLengthHeader: "90",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
};
final Map<String, String> _headers_audiotales_more = {
  Headers.contentLengthHeader: "100",
  HttpHeaders.connectionHeader: "close",
  HttpHeaders.hostHeader: "m2.audiobb.ru",
  HttpHeaders.userAgentHeader: "Apache-HttpClient/UNAVAILABLE (java 1.4)",
  "Cookie": "ipaddress=178.133.141.180",
  "Cookie2": "\$Version=1",
};

// @param cat
// 2 - cartoons
// 3 - films
// 4 - music
// 7 - audiotales
// 8 - filmstrip
// 9 - text
Future<T> searchAllAPI<T>(var cat, var query) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&search=$query';

  Response response = await dio.post(
    'http://m2.audiobb.ru/php/sql_search_get',
    options: Options(
      headers: _headers_search,
      contentType: Headers.formUrlEncodedContentType,
    ),
    data: _body,
  );

  if (response.statusCode == 200) {
    List _detailsURL = json.decode(response.data);
    var _res;

    switch (cat) {
      case 2:
        List<CartoonDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => CartoonDetailsJSON.fromJson(_detailsURL))
            .toList();
        _res = _list;
        break;
      case 3:
        List<FilmDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => FilmDetailsJSON.fromJson(_detailsURL))
            .toList();
        _res = _list;
        break;
      case 4:
        List<MusicDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => MusicDetailsJSON.fromJson(_detailsURL))
            .toList();
        for (int i = 0; i < _list.length; i++) {
          for (int j = 0; j < iosDisable.length; j++) {
            if (Platform.isIOS && _list[i].stId == iosDisable[j]) {
              _list.remove(_list[i]);
            }
          }
        }
        _res = _list;
        break;
      case 7:
        List<AudioTaleDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => AudioTaleDetailsJSON.fromJson(_detailsURL))
            .toList();
        for (int i = 0; i < _list.length; i++) {
          for (int j = 0; j < iosDisable.length; j++) {
            if (Platform.isIOS && _list[i].stId == iosDisable[j]) {
              _list.remove(_list[i]);
            }
          }
        }
        _res = _list;
        break;
      case 8:
        List<FilmstripDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => FilmstripDetailsJSON.fromJson(_detailsURL))
            .toList();
        _res = _list;
        break;
      case 9:
        List<TextDetailsJSON> _list = _detailsURL
            .map((_detailsURL) => TextDetailsJSON.fromJson(_detailsURL))
            .toList();
        _res = _list;
        break;
    }

    return _res as T;
  } else
    throw Exception('fail in load data');
}

// @param cat
// 2 - cartoons
// 3 - films
// 4 - music
// 7 - audiotales
// 8 - filmstrip
// 9 - text
Future<List<HintJSON>> hintAPI(var cat) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=$cat';

  Response response = await dio.post(
    'http://m2.audiobb.ru/php/sql_hint_getlist',
    options: Options(
      headers: _headers_hint,
      contentType: Headers.formUrlEncodedContentType,
    ),
    data: _body,
  );

  if (response.statusCode == 200) {
    List _detailsURL = json.decode(response.data);
    List<HintJSON> _list = _detailsURL
        .map((_detailsURL) => HintJSON.fromJson(_detailsURL))
        .toList();
    return _list;
  } else
    throw Exception('fail in load data');
}

Map fromPlist(String res) {
  final _urls = xml.parse(res);
  var dict = _urls.findAllElements("dict");
  List<List> _keys = [];
  List<List> _values = [];

  List<List<String>> _strKeys = List(dict.length);
  List<List<String>> _strValues = List(dict.length);

  var separ = RegExp("(<(.*?)>)");

  for (int i = 0; i < dict.length; i++) {
    _keys.add(dict.elementAt(i).findAllElements("key").toList());
    _values.add(dict.elementAt(i).findAllElements("string").toList());

    _strKeys[i] = List(_keys[i].length);
    _strValues[i] = List(_keys[i].length);
    for (var y = 0; y < _keys[i].length; y++) {
      _strKeys[i][y] = _keys[i][y].toString().replaceAll(separ, "");
      _strValues[i][y] = _values[i][y].toString().replaceAll(separ, "");
    }
  }
  return {"keys": _strKeys, "values": _strValues};
}

Future<List<TaleInf>> myMusicListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=4';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_sets_get',
      options: Options(
        headers: _headers_music,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    print(error);
    throw Exception(error);
  }
}

Future<List<MusicDetailsJSON>> myMusicDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=4&set_id=$id';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_music_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<MusicDetailsJSON> _list =
          _notOK.map((e) => MusicDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data музика');
  }
}

Future<List<TaleInf>> myTextsListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=9';
  Response response = await dio.post(
    'http://m2.audiobb.ru/php/sql_sets_get',
    options: Options(
      headers: _headers_texts,
      contentType: Headers.formUrlEncodedContentType,
    ),
    data: _body,
  );
  if (response.statusCode == 200) {
    List _urls = json.decode(response.data);

    var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
    return _res;
  } else
    throw Exception('fail in load data');
}

Future<List<TextDetailsJSON>> myTextsDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=4&set_id=$id';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_texts_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<TextDetailsJSON> _list =
          _notOK.map((e) => TextDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

//Аудиосказки
Future<List<TaleInf>> myAudioTalesListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=7';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_sets_get',
      options: Options(
        headers: _headers_audoitales,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<AudioTaleDetailsJSON>> myAudioTalesDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=7&set_id=$id';
  //try{}catch (error){}
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_audiotales_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<AudioTaleDetailsJSON> _list =
          _notOK.map((e) => AudioTaleDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<TaleInf>> myCartoonsListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=2';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_sets_get',
      options: Options(
        headers: _headers_cartoons,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<CartoonDetailsJSON>> myCartoonsDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=2&set_id=$id';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_cartoons_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<CartoonDetailsJSON> _list =
          _notOK.map((e) => CartoonDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

//Фильмы
Future<List<TaleInf>> myFilmListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=3';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_sets_get',
      options: Options(
        headers: _headers_films,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<FilmDetailsJSON>> myFilmsDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=3&set_id=$id';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_films_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<FilmDetailsJSON> _list =
          _notOK.map((e) => FilmDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

//Диафильмы
Future<List<TaleInf>> myFilmstripsListAPI() async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&type_id=8';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_sets_get',
      options: Options(
        headers: _headers_films,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<FilmstripDetailsJSON>> myFilmstripDetailsAPI(var id) async {
  Dio dio = Dio();
  String _body =
      'lang=ru&man=Xiaomi&mod=Redmi+Note+4&uid=e5cfd7c2&sid=0&pass=&pla=Android&v=4.7.2&typeid=8&set_id=$id';
  try {
    Response response = await dio.post(
      'http://m2.audiobb.ru/php/sql_items_get',
      options: Options(
        headers: _headers_filmstrips_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<FilmstripDetailsJSON> _list =
          _notOK.map((e) => FilmstripDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

//Караоке
Future<List<TaleInf>> karaokeList() async {
  Dio dio = Dio();
  String _body =
      'v=8.2.9&iosv=12.400000&lang=ru&bundleid=audiobaby.pod&pla=iPhone&uid=6B020CEA&type_id=5';

  try {
    Response response = await dio.post(
      'https://m1.audiobaby.net/php/sql_sets_get',
      options: Options(
        headers: _headers_karaoke,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );
    if (response.statusCode == 200) {
      List _urls = json.decode(response.data);

      var _res = _urls.map((_urls) => TaleInf.fromJson(_urls)).toList();
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

Future<List<KaraokeDetailsJSON>> karaokeDetails(var id) async {
  Dio dio = Dio();
  String _body =
      'v=8.2.9&iosv=12.400000&lang=ru&bundleid=audiobaby.pod&pla=iPhone&uid=6B020CEA&item_id=$id';
  try {
    Response response = await dio.post(
      'https://m1.audiobaby.net/php/sql_item_get',
      options: Options(
        headers: _headers_karaoke_more,
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: _body,
    );

    if (response.statusCode == 200) {
      List _detailsURL = json.decode(response.data);

      List _notOK = List();
      _detailsURL.forEach((el) {
        if (el == 'OK') {
        } else {
          _notOK.add(el);
        }
      });

      List<KaraokeDetailsJSON> _list =
          _notOK.map((e) => KaraokeDetailsJSON.fromJson(e)).toList();

      return _list;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

// Poteshki / Puzzles
Future<List<RhymesList>> rhymes(var id) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
      'https://data.audiobb.ru/files/list/cat_${id}_ru.plist',
      options: Options(
        contentType: "application/xml",
      ),
    );
    if (response.statusCode == 200) {
      Map map = fromPlist(response.data.toString());
      var _keys = map["keys"];
      var _values = map["values"];

      List<RhymesList> _res = List(_keys.length);
      for (var i = 0; i < _res.length; i++) {
        _res[i] = RhymesList().fromMap(Map.fromIterables(_keys[i], _values[i]));
      }
      print(_res);
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

// PoteshkiDetails / PuzzlesDetails
Future<List<RhymesList>> rhymesDetails(var id) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
      'https://data.audiobb.ru/files/list/set$id.plist',
      options: Options(
        contentType: "application/xml",
      ),
    );
    if (response.statusCode == 200) {
      Map map = fromPlist(response.data.toString());
      var _keys = map["keys"];
      var _values = map["values"];

      List<RhymesList> _res = List(_keys.length);
      for (var i = 0; i < _res.length; i++) {
        _res[i] = RhymesList().fromMap(Map.fromIterables(_keys[i], _values[i]));
      }
      print(_res);
      return _res;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}

//Тексты
Future<List<TaleInf>> textsAPI() async {
  var response;
  try {
    response =
        await http.get('https://audiotales.exyte.top/JSON/textSets.json');

    if (response.statusCode == 200) {
      List textsURL = json.decode(response.body);
      var resultText =
          textsURL.map((taleInf) => TaleInf.fromJson(taleInf)).toList();
      for (int i = 0; i < resultText.length; i++) {
        if (resultText[i].smokingContent == '1') {
          resultText.remove(resultText[i]);
        }
      }
      return resultText;
    }
  } catch (error) {
    throw Exception('fail in load data');
  }
}
