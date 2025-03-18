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
  @override
  void initState() {
    super.initState();
    _init();
    musicData = fetchMusicData(theURL, theStationID);
    nextSongsData = fetchingNextSongs();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        musicData = fetchMusicData(theURL, theStationID);
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

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.all(20),
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
              PlayButtonAndVolume(player: player),
              SizedBox(
                height: 0,
              ),
              SongHistoryAndRequestSongButtons(
                  
                  musicData: musicData,
                  textEditingController: textEditingController,
                  nextSongsData: nextSongsData),
            ],
          )),
    );
  }
}



