// To parse this JSON data, do
//
//     final nextSongsData = nextSongsDataFromJson(jsonString);

import 'dart:convert';

List<NextSongsData> nextSongsDataFromJson(String str) =>
    List<NextSongsData>.from(
        json.decode(str).map((x) => NextSongsData.fromJson(x)));

String nextSongsDataToJson(List<NextSongsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NextSongsData {
  int? cuedAt;
  int? playedAt;
  double? duration;
  String? playlist;
  bool? isRequest;
  Song? song;
  bool? sentToAutodj;
  bool? isPlayed;
  dynamic autodjCustomUri;
  List<String>? log;
  Links? links;

  NextSongsData({
    this.cuedAt,
    this.playedAt,
    this.duration,
    this.playlist,
    this.isRequest,
    this.song,
    this.sentToAutodj,
    this.isPlayed,
    this.autodjCustomUri,
    this.log,
    this.links,
  });

  factory NextSongsData.fromJson(Map<String, dynamic> json) => NextSongsData(
        cuedAt: json["cued_at"],
        playedAt: json["played_at"],
        duration: json["duration"]?.toDouble(),
        playlist: json["playlist"],
        isRequest: json["is_request"],
        song: json["song"] == null ? null : Song.fromJson(json["song"]),
        sentToAutodj: json["sent_to_autodj"],
        isPlayed: json["is_played"],
        autodjCustomUri: json["autodj_custom_uri"],
        log: json["log"] == null
            ? []
            : List<String>.from(json["log"]!.map((x) => x)),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "cued_at": cuedAt,
        "played_at": playedAt,
        "duration": duration,
        "playlist": playlist,
        "is_request": isRequest,
        "song": song?.toJson(),
        "sent_to_autodj": sentToAutodj,
        "is_played": isPlayed,
        "autodj_custom_uri": autodjCustomUri,
        "log": log == null ? [] : List<dynamic>.from(log!.map((x) => x)),
        "links": links?.toJson(),
      };
}

class Links {
  String? self;

  Links({
    this.self,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
      };
}

class Song {
  String? id;
  String? art;
  List<dynamic>? customFields;
  String? text;
  String? artist;
  String? title;
  String? album;
  String? genre;
  String? isrc;
  String? lyrics;

  Song({
    this.id,
    this.art,
    this.customFields,
    this.text,
    this.artist,
    this.title,
    this.album,
    this.genre,
    this.isrc,
    this.lyrics,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        art: json["art"],
        customFields: json["custom_fields"] == null
            ? []
            : List<dynamic>.from(json["custom_fields"]!.map((x) => x)),
        text: json["text"],
        artist: json["artist"],
        title: json["title"],
        album: json["album"],
        genre: json["genre"],
        isrc: json["isrc"],
        lyrics: json["lyrics"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "art": art,
        "custom_fields": customFields == null
            ? []
            : List<dynamic>.from(customFields!.map((x) => x)),
        "text": text,
        "artist": artist,
        "title": title,
        "album": album,
        "genre": genre,
        "isrc": isrc,
        "lyrics": lyrics,
      };
}
