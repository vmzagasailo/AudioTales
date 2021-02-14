
//used for music.dart audioTales.dart cartoons.dart
class TaleInf {
  final String id;
  final String name, desc, count, smokingContent, iosContent;

  TaleInf({
    this.id,
    this.name,
    this.desc,
    this.count,
    this.smokingContent,
    this.iosContent,
  });

  factory TaleInf.fromJson(Map<String, dynamic> jsonData) {
    return TaleInf(
      id: jsonData['id'],
      name: jsonData['name'],
      desc: jsonData['desc'],
      count: jsonData['count'],
      smokingContent: jsonData['smoking_content'],
      iosContent: jsonData['ios_disable'],
    );
  }
}

// hints.dart
class HintJSON {
  final String id;
  final String header, text, rating;

  HintJSON({
    this.id,
    this.header,
    this.text,
    this.rating,
  });

  factory HintJSON.fromJson(Map<String, dynamic> jsonData) {
    return HintJSON(
      id: jsonData['id'],
      header: jsonData['header'],
      text: jsonData['text'],
      rating: jsonData['rating'],
    );
  }
}

//audioTaleDetails.dart
class AudioTaleDetailsJSON {
  final String pageId, id, stId;

  final String name, size, rating, author,duration, img, iosImage;
  bool favorite;
  bool checkPlaylist;

  AudioTaleDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.rating,
    this.size,
    this.author,
    this.duration,
    this.name,
    this.img,
    this.favorite = false,
    this.iosImage,
    this.checkPlaylist,
  });


  factory AudioTaleDetailsJSON.fromJson(Map<String, dynamic> jsonData) => AudioTaleDetailsJSON(
    id: jsonData['id'],
    stId: jsonData['set_id'],
    pageId: jsonData['page_id'],
    rating: jsonData['rating'],
    size: jsonData['mp3_size'],
    duration: jsonData['duration'],
    name: jsonData['name'],
    author: jsonData['author'],
    img: jsonData['has_img'],
    iosImage: jsonData['ios_image'],
    favorite: false,
    checkPlaylist: false,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'set_id': stId,
        'pageId': pageId,
        'rating': rating,
        'mp3_size': size,
        'duration': duration,
        'name': name,
        'author': author,
        'has_img': img,
        'ios_image': iosImage,
        'favorite': favorite,
        'checkPlaylist' : checkPlaylist,
      };
}

//musicDetails.dart
class MusicDetailsJSON {
  final String pageId, id, stId;
  final String name, size, rating, duration, img,iosImage;
  bool favorite;
  bool checkPL;

  MusicDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.rating,
    this.size,
    this.duration,
    this.name,
    this.img,
    this.iosImage,
    this.favorite = false,
    this.checkPL,
  });


  factory MusicDetailsJSON.fromJson(Map<String, dynamic> jsonData) => MusicDetailsJSON(
    id: jsonData['id'],
    stId: jsonData['set_id'],
    pageId: jsonData['page_id'],
    rating: jsonData['rating'],
    size: jsonData['mp3_size'],
    duration: jsonData['duration'],
    name: jsonData['name'],
    img: jsonData['has_img'],
    favorite: false,
    checkPL: false,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'set_id': stId,
        'pageId': pageId,
        'rating': rating,
        'mp3_size': size,
        'duration': duration,
        'name': name,
        'has_img': img,
        'favorite': favorite,
        'checkPL' : checkPL,
      };
}

//cartoonDetails
class CartoonDetailsJSON {
  final String pageId, id, stId;
  final String name, author, popularity, duration, img, url;

  CartoonDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.author,
    this.popularity,
    this.duration,
    this.name,
    this.img,
    this.url,
  });


  factory CartoonDetailsJSON.fromJson(Map<String, dynamic> jsonData) => CartoonDetailsJSON(
    id: jsonData['id'],
    stId: jsonData['set_id'],
    pageId: jsonData['page_id'],
    author: jsonData['author'],
    popularity: jsonData['popularity'],
    duration: jsonData['duration'],
    name: jsonData['name'],
    img: jsonData['has_img'],
    url: jsonData['caf_size'],
  );
  Map<String, dynamic> toJson() =>{
    'id': id,
    'set_id': stId,
    'pageId': pageId,
    'author': author,
    'popularity': popularity,
    'duration': duration,
    'name': name,
    'has_img': img,
    'caf_size': url,
  };
}

//filmsDetails.dart
class FilmDetailsJSON {
  final String pageId, id, stId;
  final String name, author, popularity, duration, img, url;
  bool favorite;

  FilmDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.author,
    this.popularity,
    this.duration,
    this.name,
    this.img,
    this.url,
    this.favorite,
  });


  factory FilmDetailsJSON.fromJson(Map<String, dynamic> jsonData) => FilmDetailsJSON(
    id: jsonData['id'],
    stId: jsonData['set_id'],
    pageId: jsonData['page_id'],
    author: jsonData['author'],
    popularity: jsonData['popularity'],
    duration: jsonData['duration'],
    name: jsonData['name'],
    img: jsonData['has_img'],
    url: jsonData['caf_size'],
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'set_id': stId,
        'pageId': pageId,
        'author': author,
        'popularity': popularity,
        'duration': duration,
        'name': name,
        'has_img': img,
        'caf_size': url,
      };
}

//textDetails.dart
class TextDetailsJSON {
  final String pageId, id, stId;
  final String name, author, popularity, duration, img;
  bool favorite;

  TextDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.author,
    this.popularity,
    this.duration,
    this.name,
    this.img,
    this.favorite,
  });


  factory TextDetailsJSON.fromJson(Map<String, dynamic> jsonData)=> TextDetailsJSON(
    id: jsonData['id'],
    stId: jsonData['set_id'],
    pageId: jsonData['page_id'],
    author: jsonData['author'],
    popularity: jsonData['popularity'],
    duration: jsonData['duration'],
    name: jsonData['name'],
    img: jsonData['has_img'],
    favorite: false,
  );



  Map<String, dynamic> toJson() => {
        'id': id,
        'set_id': stId,
        'pageId': pageId,
        'author': author,
        'popularity': popularity,
        'duration': duration,
        'name': name,
        'has_img': img,
        'favorite': favorite,
      };
}

class FilmstripDetailsJSON {
  final String pageId, id, stId;
  final String name, author, popularity, duration, img, size;
  bool favorite;

  FilmstripDetailsJSON({
    this.id,
    this.stId,
    this.pageId,
    this.author,
    this.popularity,
    this.duration,
    this.name,
    this.img,
    this.size,
    this.favorite = false,
  });

  factory FilmstripDetailsJSON.fromJson(Map<String, dynamic> jsonData) =>
      FilmstripDetailsJSON(
        id: jsonData['id'],
        stId: jsonData['set_id'],
        pageId: jsonData['page_id'],
        author: jsonData['author'],
        popularity: jsonData['popularity'],
        duration: jsonData['duration'],
        name: jsonData['name'],
        img: jsonData['has_img'],
        size: jsonData['caf_size'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'set_id': stId,
        'pageId': pageId,
        'author': author,
        'popularity': popularity,
        'duration': duration,
        'name': name,
        'has_img': img,
        'caf_size': size,
      };
}

class SearchJSON {
  final int type;
  final String pageId, id, stId;
  final String name, author, rating, duration, size;
  bool favorite;

  SearchJSON({
    this.type,
    this.id,
    this.stId,
    this.pageId,
    this.author,
    this.rating,
    this.duration,
    this.name,
    this.size,
    this.favorite,
  });
}

//KaraokeDetails.dart
class KaraokeDetailsJSON {
  final String iapId, id, cafSize;
  final String name, author, nameAlt, duration, desc;
  bool favorite;

  KaraokeDetailsJSON({
    this.id,
    this.iapId,
    this.cafSize,
    this.desc,
    this.author,
    this.duration,
    this.name,
    this.nameAlt,
    this.favorite = false,
  });

  fromMap(Map<String, dynamic> map) => KaraokeDetailsJSON(
        id: map['id'],
        iapId: map['iap_id'],
        desc: map['desc'],
        cafSize: map['caf_size'],
        author: map['author'],
        duration: map['duration'],
        name: map['name'],
        nameAlt: map['name_alt'],
        favorite: false,
      );

  factory KaraokeDetailsJSON.fromJson(Map<String, dynamic> jsonData) =>
      KaraokeDetailsJSON(
        id: jsonData['id'],
        iapId: jsonData['iap_id'],
        desc: jsonData['desc'],
        cafSize: jsonData['caf_size'],
        author: jsonData['author'],
        duration: jsonData['duration'],
        name: jsonData['name'],
        nameAlt: jsonData['name_alt'],
        favorite: false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'iap_id': iapId,
        'desc': desc,
        'caf_size': cafSize,
        'author': author,
        'duration': duration,
        'name': name,
        'name_alt': nameAlt,
        'favorite': favorite,
      };
}

//RhymesList.dart
class RhymesList {
  final String id, name, desc;
  final String count, order, rating, set_id, iosImage;
  bool favorite;

  RhymesList({
    this.id,
    this.name,
    this.desc,
    this.count,
    this.order,
    this.rating,
    this.set_id,
    this.favorite,
    this.iosImage,
  });
  fromMap(Map<String, dynamic> map) => RhymesList(
        id: map['id'],
        name: map['name'],
        desc: map['desc'],
        count: map['count'],
        order: map['order'],
        rating: map['rating'],
        set_id: map['set_id'],
        favorite: false,
      );
  factory RhymesList.fromJson(Map<String, dynamic> jsonData) => RhymesList(
        id: jsonData['id'],
        name: jsonData['name'],
        desc: jsonData['desc'],
        count: jsonData['count'],
        order: jsonData['order'],
        rating: jsonData['rating'],
        set_id: jsonData['set_id'],
        favorite: false,
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'count': count,
        'order': order,
        'rating': rating,
        'set_id': set_id,
        'favorite': favorite,
      };
}
