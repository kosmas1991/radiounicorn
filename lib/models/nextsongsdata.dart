class NextSongsData {
  int? cuedAt;
  int? playedAt;
  int? duration;
  String? playlist;
  bool? isRequest;
  Song? song;
  bool? sentToAutodj;
  bool? isPlayed;
  Null autodjCustomUri;
  List<String>? log;
  Links? links;

  NextSongsData(
      {this.cuedAt,
      this.playedAt,
      this.duration,
      this.playlist,
      this.isRequest,
      this.song,
      this.sentToAutodj,
      this.isPlayed,
      this.autodjCustomUri,
      this.log,
      this.links});

  NextSongsData.fromJson(Map<String, dynamic> json) {
    cuedAt = json['cued_at'];
    playedAt = json['played_at'];
    duration = json['duration'];
    playlist = json['playlist'];
    isRequest = json['is_request'];
    song = json['song'] != null ? new Song.fromJson(json['song']) : null;
    sentToAutodj = json['sent_to_autodj'];
    isPlayed = json['is_played'];
    autodjCustomUri = json['autodj_custom_uri'];
    log = json['log'].cast<String>();
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cued_at'] = this.cuedAt;
    data['played_at'] = this.playedAt;
    data['duration'] = this.duration;
    data['playlist'] = this.playlist;
    data['is_request'] = this.isRequest;
    if (this.song != null) {
      data['song'] = this.song!.toJson();
    }
    data['sent_to_autodj'] = this.sentToAutodj;
    data['is_played'] = this.isPlayed;
    data['autodj_custom_uri'] = this.autodjCustomUri;
    data['log'] = this.log;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class Song {
  String? id;
  String? text;
  String? artist;
  String? title;
  String? album;
  String? genre;
  String? isrc;
  String? lyrics;
  String? art;
  List<Null>? customFields;

  Song(
      {this.id,
      this.text,
      this.artist,
      this.title,
      this.album,
      this.genre,
      this.isrc,
      this.lyrics,
      this.art,
      this.customFields});

  Song.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    artist = json['artist'];
    title = json['title'];
    album = json['album'];
    genre = json['genre'];
    isrc = json['isrc'];
    lyrics = json['lyrics'];
    art = json['art'];
    if (json['custom_fields'] != null) {
      customFields = <Null>[];
      json['custom_fields'].forEach((v) {
       
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['artist'] = this.artist;
    data['title'] = this.title;
    data['album'] = this.album;
    data['genre'] = this.genre;
    data['isrc'] = this.isrc;
    data['lyrics'] = this.lyrics;
    data['art'] = this.art;
    if (this.customFields != null) {

    }
    return data;
  }
}

class Links {
  String? self;

  Links({this.self});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['self'] = this.self;
    return data;
  }
}
