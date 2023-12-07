import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radiounicorn/cubits/playing/playing_cubit.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'dart:async';

import 'package:transparent_image/transparent_image.dart';

class Player extends StatefulWidget {
  final FlutterRadioPlayer flutterRadioPlayer;
  const Player({required this.flutterRadioPlayer, super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late Future<MusicData> musicData;
  final FRPSource frpSource = FRPSource(
    mediaSources: <MediaSources>[
      MediaSources(
          url: "https://radiounicorn.eu:8000/radio.mp3",
          description: "radio unicorn LIVE",
          isPrimary: true,
          title: "unicorn",
          isAac: true),
    ],
  );
  @override
  void initState() {
    super.initState();
    widget.flutterRadioPlayer.initPlayer();
    widget.flutterRadioPlayer.addMediaSources(frpSource);
    musicData = fetching();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 20), (timer) {
      setState(() {
        musicData = fetching();
      });
    });
    return Center(
      child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.black54),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadioTitle(),
              SizedBox(
                height: 15,
              ),
              ImageAndTitle(),
              SizedBox(
                height: 10,
              ),
              PlayButtonAndVolume()
            ],
          )),
    );
  }

  Widget RadioTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'radio unicorn',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget ImageAndTitle() {
    return FutureBuilder<MusicData>(
        future: musicData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FadeInImage.memoryNetwork(
                    height: 50,
                    placeholder: kTransparentImage,
                    image: '${snapshot.data!.nowPlaying!.song!.art}',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.data!.nowPlaying!.song!.title}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${snapshot.data!.nowPlaying!.song!.artist}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Widget PlayButtonAndVolume() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<PlayingCubit, PlayingState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () {
                  widget.flutterRadioPlayer.playOrPause();
                },
                icon: Icon(
                  state.playing == true
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 40,
                  color: Colors.blue,
                ));
          },
        ),
        Text(
          'volume',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

Future<MusicData> fetching() async {
  var response =
      await http.get(Uri.parse('https://radiounicorn.eu/api/nowplaying'));
  if (response.statusCode == 200) {
    return MusicData.fromJson(
        jsonDecode(response.body.substring(1, response.body.length - 1))
            as Map<String, dynamic>);
  } else {
    throw Exception('Failed');
  }
}
