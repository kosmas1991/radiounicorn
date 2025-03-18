import 'dart:async';
import 'package:flutter/material.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:radiounicorn/widgets/history_request_next/next_songs.dart';
import 'package:radiounicorn/widgets/history_request_next/request_song.dart';
import 'package:radiounicorn/widgets/history_request_next/song_history.dart';

class SongHistoryAndRequestSongButtons extends StatelessWidget {
  const SongHistoryAndRequestSongButtons({
    super.key,
    required this.musicData,
    required this.textEditingController,
    required this.nextSongsData,
  });

  final Future<MusicData> musicData;
  final TextEditingController textEditingController;
  final Future<List<NextSongsData>> nextSongsData;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        songHistory(
            musicData: musicData,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
        RequestSong(textEditingController: textEditingController, screenWidth: screenWidth, screenHeight: screenHeight),
        NextSongs(nextSongsData: nextSongsData, screenWidth: screenWidth, screenHeight: screenHeight),
      ],
    );
  }
}
