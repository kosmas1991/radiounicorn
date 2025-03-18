import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radiounicorn/main.dart';
import 'package:radiounicorn/mainVars.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:radiounicorn/models/requestsongdata.dart';

Future<MusicData> fetchMusicData(String theURL, int theStationID) async {
  var response =
      await http.get(Uri.parse('${theURL}/api/nowplaying/${theStationID}'));

  if (response.statusCode == 200) {
    return MusicData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed');
  }
}

Future<List<RequestSongData>> fetchSongRequestList(
    String theURL, int theStationID) async {
  var response = await http
      .get(Uri.parse('${theURL}/api/station/${theStationID}/requests'));

  if (response.statusCode == 200) {
    List<RequestSongData> data = (json.decode(response.body) as List)
        .map((i) => RequestSongData.fromJson(i))
        .toList();
    return data;
  } else {
    throw Exception('Failed');
  }
}

Future<List<NextSongsData>> fetchingNextSongs() async {
  final headers = {
    'accept': 'application/json',
    'X-API-Key': '${key}',
  };
  final url = Uri.parse('${theURL}/api/station/${theStationID}/queue');
  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List<NextSongsData> nextSongsDatas;
    nextSongsDatas = (json.decode(response.body) as List)
        .map((i) => NextSongsData.fromJson(i))
        .toList();
    return nextSongsDatas;
  } else {
    throw Exception('Failed');
  }
}

void requestNewSong(String url) async {
  BuildContext context = MyApp.navigatorKey.currentState!.context;
  var response = await http.get(Uri.parse('${theURL}${url}'));
  if (response.body.contains('"success":true')) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Song just added to the song queue',
      style: TextStyle(color: Colors.green),
    )));
  } else if (response.body.contains('Duplicate request')) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Failed! Song already requested!',
      style: TextStyle(color: Colors.red),
    )));
  } else if (response.body.contains('played too recently')) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Failed! Same song or artist played too recently!',
      style: TextStyle(color: Colors.red),
    )));
  } else if (response.body.contains('a request too recently')) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Failed! You asked for another request too recently!',
      style: TextStyle(color: Colors.red),
    )));
  } else {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Failed!',
      style: TextStyle(color: Colors.red),
    )));
  }
}
