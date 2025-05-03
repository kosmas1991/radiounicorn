import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/logic/functions.dart';
import 'package:radiounicorn/mainVars.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:radiounicorn/models/requestsongdata.dart';
import 'package:radiounicorn/widgets/image_and_title.dart';
import 'package:radiounicorn/widgets/play_button_and_volume.dart';
import 'package:radiounicorn/widgets/radio_title.dart';
import 'package:radiounicorn/widgets/history_request_next/history_request_next_songs.dart';
import 'dart:async';
import 'dart:math';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final player = AudioPlayer();
  double volume = 1;
  TextEditingController textEditingController = TextEditingController();
  late Future<MusicData> musicData;
  late Future<List<NextSongsData>> nextSongsData;
  late Future<List<RequestSongData>> reqData;

  int songDuration = 0;
  int songElapsed = 0;
  int songRemaining = 0;
  double progressPercentage = 0.0;
  Timer? progressTimer;

  DateTime? songStartTime;
  String? currentSongId;
  int lastKnownElapsed = 0;

  @override
  void initState() {
    super.initState();
    _init();
    musicData = fetchMusicData(theURL, theStationID);
    musicData.then((data) {
      _updateSongProgress(data);
    });
    _startProgressTimer();

    nextSongsData = fetchingNextSongs();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        musicData = fetchMusicData(theURL, theStationID);
        musicData.then((data) {
          _updateSongProgress(data);
        });

        nextSongsData = fetchingNextSongs();
      });
    });
    reqData = fetchSongRequestList(theURL, theStationID);
    reqData.then(
        (value) => context.read<RequestsonglistCubit>().emitNewList(value));
  }

  Future<void> _init() async {
    await player.setUrl(
      playerURL,
      tag: MediaItem(
        id: '1',
        title: stationName,
        artist: 'stream',
        isLive: true,
        artUri: Uri.parse(logoURL),
      ),
    );
    await player.setVolume(volume);
    await player.play();
  }

  void _updateSongProgress(MusicData data) {
    if (data.nowPlaying != null) {
      final newSongId = data.nowPlaying?.song?.id;
      final serverDuration = data.nowPlaying?.duration ?? 0;
      final serverElapsed = data.nowPlaying?.elapsed ?? 0;

      setState(() {
        songDuration = serverDuration;
        if (currentSongId != newSongId) {
          currentSongId = newSongId;
          songStartTime =
              DateTime.now().subtract(Duration(seconds: serverElapsed));
          lastKnownElapsed = serverElapsed;
          songElapsed = serverElapsed;
          songRemaining = songDuration - songElapsed;
        } else {
          if (serverElapsed > lastKnownElapsed) {
            songStartTime =
                DateTime.now().subtract(Duration(seconds: serverElapsed));
            lastKnownElapsed = serverElapsed;
          }
          final calculatedElapsed = songStartTime != null
              ? DateTime.now().difference(songStartTime!).inSeconds
              : 0;

          songElapsed =
              max(calculatedElapsed, lastKnownElapsed).clamp(0, songDuration);
          songRemaining = songDuration - songElapsed;
        }
        if (songDuration > 0) {
          progressPercentage = songElapsed / songDuration;
        } else {
          progressPercentage = 0.0;
        }
      });
    }
  }

  void _startProgressTimer() {
    progressTimer?.cancel();
    progressTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (songStartTime != null && songDuration > 0) {
        setState(() {
          final calculatedElapsed =
              DateTime.now().difference(songStartTime!).inSeconds;
          songElapsed =
              max(calculatedElapsed, lastKnownElapsed).clamp(0, songDuration);
          songRemaining = songDuration - songElapsed;
          progressPercentage = songElapsed / songDuration;
        });
      }
    });
  }

  @override
  void dispose() {
    progressTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 600,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadioTitle(musicData: musicData),
              SizedBox(
                height: 15,
              ),
              ImageAndTitle(context: context, musicData: musicData),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  minHeight: 6,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              ),
              SizedBox(height: 10),
              PlayButtonAndVolume(player: player),
              SizedBox(height: 10),
              SongHistoryAndRequestSongButtons(
                  musicData: musicData,
                  textEditingController: textEditingController,
                  nextSongsData: nextSongsData),
            ],
          )),
    );
  }
}
