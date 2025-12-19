class MusicData {
  Station? station;
  Listeners? listeners;
  Live? live;
  NowPlaying? nowPlaying;
  PlayingNext? playingNext;
  List<SongHistory>? songHistory;
  bool? isOnline;
  Null cache;

  MusicData(
      {this.station,
      this.listeners,
      this.live,
      this.nowPlaying,
      this.playingNext,
      this.songHistory,
      this.isOnline,
      this.cache});

  MusicData.fromJson(Map<String, dynamic> json) {
    station =
        json['station'] != null ? new Station.fromJson(json['station']) : null;
    listeners = json['listeners'] != null
        ? new Listeners.fromJson(json['listeners'])
        : null;
    live = json['live'] != null ? new Live.fromJson(json['live']) : null;
    nowPlaying = json['now_playing'] != null
        ? new NowPlaying.fromJson(json['now_playing'])
        : null;
    playingNext = json['playing_next'] != null
        ? new PlayingNext.fromJson(json['playing_next'])
        : null;
    if (json['song_history'] != null) {
      songHistory = <SongHistory>[];
      json['song_history'].forEach((v) {
        songHistory!.add(new SongHistory.fromJson(v));
      });
    }
    isOnline = json['is_online'];
    cache = json['cache'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.station != null) {
      data['station'] = this.station!.toJson();
    }
    if (this.listeners != null) {
      data['listeners'] = this.listeners!.toJson();
    }
    if (this.live != null) {
      data['live'] = this.live!.toJson();
    }
    if (this.nowPlaying != null) {
      data['now_playing'] = this.nowPlaying!.toJson();
    }
    if (this.playingNext != null) {
      data['playing_next'] = this.playingNext!.toJson();
    }
    if (this.songHistory != null) {
      data['song_history'] = this.songHistory!.map((v) => v.toJson()).toList();
    }
    data['is_online'] = this.isOnline;
    data['cache'] = this.cache;
    return data;
  }
}

class Station {
  int? id;
  String? name;
  String? shortcode;
  String? description;
  String? frontend;
  String? backend;
  String? listenUrl;
  String? url;
  String? publicPlayerUrl;
  String? playlistPlsUrl;
  String? playlistM3uUrl;
  bool? isPublic;
  List<Mounts>? mounts;
  List<Null>? remotes;
  bool? hlsEnabled;
  Null hlsUrl;
  int? hlsListeners;

  Station(
      {this.id,
      this.name,
      this.shortcode,
      this.description,
      this.frontend,
      this.backend,
      this.listenUrl,
      this.url,
      this.publicPlayerUrl,
      this.playlistPlsUrl,
      this.playlistM3uUrl,
      this.isPublic,
      this.mounts,
      this.remotes,
      this.hlsEnabled,
      this.hlsUrl,
      this.hlsListeners});

  Station.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortcode = json['shortcode'];
    description = json['description'];
    frontend = json['frontend'];
    backend = json['backend'];
    listenUrl = json['listen_url'];
    url = json['url'];
    publicPlayerUrl = json['public_player_url'];
    playlistPlsUrl = json['playlist_pls_url'];
    playlistM3uUrl = json['playlist_m3u_url'];
    isPublic = json['is_public'];
    if (json['mounts'] != null) {
      mounts = <Mounts>[];
      json['mounts'].forEach((v) {
        mounts!.add(new Mounts.fromJson(v));
      });
    }
    if (json['remotes'] != null) {
      remotes = <Null>[];
      json['remotes'].forEach((v) {});
    }
    hlsEnabled = json['hls_enabled'];
    hlsUrl = json['hls_url'];
    hlsListeners = json['hls_listeners'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shortcode'] = this.shortcode;
    data['description'] = this.description;
    data['frontend'] = this.frontend;
    data['backend'] = this.backend;
    data['listen_url'] = this.listenUrl;
    data['url'] = this.url;
    data['public_player_url'] = this.publicPlayerUrl;
    data['playlist_pls_url'] = this.playlistPlsUrl;
    data['playlist_m3u_url'] = this.playlistM3uUrl;
    data['is_public'] = this.isPublic;
    if (this.mounts != null) {
      data['mounts'] = this.mounts!.map((v) => v.toJson()).toList();
    }
    if (this.remotes != null) {}
    data['hls_enabled'] = this.hlsEnabled;
    data['hls_url'] = this.hlsUrl;
    data['hls_listeners'] = this.hlsListeners;
    return data;
  }
}

class Mounts {
  int? id;
  String? name;
  String? url;
  int? bitrate;
  String? format;
  Listeners? listeners;
  String? path;
  bool? isDefault;

  Mounts(
      {this.id,
      this.name,
      this.url,
      this.bitrate,
      this.format,
      this.listeners,
      this.path,
      this.isDefault});

  Mounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    bitrate = json['bitrate'];
    format = json['format'];
    listeners = json['listeners'] != null
        ? new Listeners.fromJson(json['listeners'])
        : null;
    path = json['path'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['bitrate'] = this.bitrate;
    data['format'] = this.format;
    if (this.listeners != null) {
      data['listeners'] = this.listeners!.toJson();
    }
    data['path'] = this.path;
    data['is_default'] = this.isDefault;
    return data;
  }
}

class Listeners {
  int? total;
  int? unique;
  int? current;

  Listeners({this.total, this.unique, this.current});

  Listeners.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unique = json['unique'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['unique'] = this.unique;
    data['current'] = this.current;
    return data;
  }
}

class Live {
  bool? isLive;
  String? streamerName;
  Null broadcastStart;
  Null art;

  Live({this.isLive, this.streamerName, this.broadcastStart, this.art});

  Live.fromJson(Map<String, dynamic> json) {
    isLive = json['is_live'];
    streamerName = json['streamer_name'];
    broadcastStart = json['broadcast_start'];
    art = json['art'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_live'] = this.isLive;
    data['streamer_name'] = this.streamerName;
    data['broadcast_start'] = this.broadcastStart;
    data['art'] = this.art;
    return data;
  }
}

class NowPlaying {
  int? shId;
  int? playedAt;
  int? duration;
  String? playlist;
  String? streamer;
  bool? isRequest;
  Song? song;
  int? elapsed;
  int? remaining;

  NowPlaying(
      {this.shId,
      this.playedAt,
      this.duration,
      this.playlist,
      this.streamer,
      this.isRequest,
      this.song,
      this.elapsed,
      this.remaining});

  NowPlaying.fromJson(Map<String, dynamic> json) {
    shId = json['sh_id'];
    playedAt = json['played_at'] is int ? json['played_at'] : (json['played_at'] as num?)?.toInt();
    duration = json['duration'] is int ? json['duration'] : (json['duration'] as num?)?.toInt();
    playlist = json['playlist'];
    streamer = json['streamer'];
    isRequest = json['is_request'];
    song = json['song'] != null ? new Song.fromJson(json['song']) : null;
    elapsed = json['elapsed'] is int ? json['elapsed'] : (json['elapsed'] as num?)?.toInt();
    remaining = json['remaining'] is int ? json['remaining'] : (json['remaining'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sh_id'] = this.shId;
    data['played_at'] = this.playedAt;
    data['duration'] = this.duration;
    data['playlist'] = this.playlist;
    data['streamer'] = this.streamer;
    data['is_request'] = this.isRequest;
    if (this.song != null) {
      data['song'] = this.song!.toJson();
    }
    data['elapsed'] = this.elapsed;
    data['remaining'] = this.remaining;
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
      json['custom_fields'].forEach((v) {});
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
      data['custom_fields'] = this.customFields!.map((v) {}).toList();
    }
    return data;
  }
}

class PlayingNext {
  int? cuedAt;
  int? playedAt;
  int? duration;
  String? playlist;
  bool? isRequest;
  Song? song;

  PlayingNext(
      {this.cuedAt,
      this.playedAt,
      this.duration,
      this.playlist,
      this.isRequest,
      this.song});

  PlayingNext.fromJson(Map<String, dynamic> json) {
    cuedAt = json['cued_at'] is int ? json['cued_at'] : (json['cued_at'] as num?)?.toInt();
    playedAt = json['played_at'] is int ? json['played_at'] : (json['played_at'] as num?)?.toInt();
    duration = json['duration'] is int ? json['duration'] : (json['duration'] as num?)?.toInt();
    playlist = json['playlist'];
    isRequest = json['is_request'];
    song = json['song'] != null ? new Song.fromJson(json['song']) : null;
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
    return data;
  }
}

class SongHistory {
  int? shId;
  int? playedAt;
  int? duration;
  String? playlist;
  String? streamer;
  bool? isRequest;
  Song? song;

  SongHistory(
      {this.shId,
      this.playedAt,
      this.duration,
      this.playlist,
      this.streamer,
      this.isRequest,
      this.song});

  SongHistory.fromJson(Map<String, dynamic> json) {
    shId = json['sh_id'];
    playedAt = json['played_at'];
    duration = json['duration'];
    playlist = json['playlist'];
    streamer = json['streamer'];
    isRequest = json['is_request'];
    song = json['song'] != null ? new Song.fromJson(json['song']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sh_id'] = this.shId;
    data['played_at'] = this.playedAt;
    data['duration'] = this.duration;
    data['playlist'] = this.playlist;
    data['streamer'] = this.streamer;
    data['is_request'] = this.isRequest;
    if (this.song != null) {
      data['song'] = this.song!.toJson();
    }
    return data;
  }
}
