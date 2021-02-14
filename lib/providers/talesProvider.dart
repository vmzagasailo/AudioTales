import 'dart:io';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import '../modelJSON/taleInf.dart';
import '../resource/api/api.dart';
import 'package:audiotales/modelJSON/globalData.dart';

class TalesProvider with ChangeNotifier {
  Future<List<TaleInf>> fetchAudioTalesList() async {
    return await myAudioTalesListAPI();
  }

  Future<List<AudioTaleDetailsJSON>> fetchAudioTalesDetails(var id) async {
    return await myAudioTalesDetailsAPI(id);
  }

  Future<List<TaleInf>> fetchMusicList() async {
    return await myMusicListAPI();
  }

  Future<List<MusicDetailsJSON>> fetchMusicDetails(var id) async {
    return await myMusicDetailsAPI(id);
  }

  Future<List<TaleInf>> fetchCartoonsList() async {
    return await myCartoonsListAPI();
  }

  Future<List<CartoonDetailsJSON>> fetchCartoonsDetails(var id) async {
    return await myCartoonsDetailsAPI(id);
  }

  Future<List<TaleInf>> fetchFilmsList() async {
    return await myFilmListAPI();
  }

  Future<List<FilmDetailsJSON>> fetchFilmsDetails(var id) async {
    return await myFilmsDetailsAPI(id);
  }

  Future<List<TaleInf>> fetchFilmstripsList() async {
    return await myFilmstripsListAPI();
  }

  Future<List<FilmstripDetailsJSON>> fetchFilmstripsDetails(var id) async {
    return await myFilmstripDetailsAPI(id);
  }

  Future<List<TaleInf>> fetchKaraokeList() async {
    return await karaokeList();
  }

  Future<List<KaraokeDetailsJSON>> fetchKaraokeDetails(var id) async {
    return await karaokeDetails(id);
  }

  Future<List<RhymesList>> fetchPuzzlesList(var id) async {
    return await rhymes(10);
  }

  Future<List<RhymesList>> fetchPuzzlesDetails(var id) async {
    return await rhymesDetails(id);
  }

  Future<List<RhymesList>> fetchRhymesList(var id) async {
    return await rhymes(1);
  }

  Future<List<RhymesList>> fetchRhymesDetails(var id) async {
    return await rhymesDetails(id);
  }

  Future<List<TaleInf>> fetchTextsList() async {
    return await myTextsListAPI();
  }
}
