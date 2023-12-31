import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radiounicorn/cubits/playing/playing_cubit.dart';
import 'package:radiounicorn/cubits/volume/volume_cubit.dart';
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
  double volume = 0.5;
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
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        musicData = fetching();
      });
    });
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
              RadioTitle(),
              SizedBox(
                height: 15,
              ),
              ImageAndTitle(),
              SizedBox(
                height: 10,
              ),
              PlayButtonAndVolume(),
              SizedBox(
                height: 0,
              ),
              SongHistoryButton(),
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
    double screenWidth = MediaQuery.of(context).size.width;
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
                    Container(
                      width: screenWidth*5/9,
                      child: Text(
                        '${snapshot.data!.nowPlaying!.song!.title}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        softWrap: false,
                      ),
                    ),
                    Text(
                      '${snapshot.data!.nowPlaying!.song!.artist}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.clip,
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
        Row(
          children: [
            Icon(
              Icons.volume_mute,
              color: Colors.grey,
              size: 20,
            ),
            BlocBuilder<VolumeCubit, VolumeState>(
              builder: (context, state) {
                return Slider(
                  activeColor: Colors.grey,
                  value: state.volume,
                  onChanged: (value) {
                    widget.flutterRadioPlayer.getPlaybackState().then((value) {
                      print('DA      STATE    IS    :   ${value}');
                      if (value == 'PLAYING') {
                        context.read<PlayingCubit>().emitNewState(true);
                      }
                    });
                    context.read<VolumeCubit>().setNewVolume(value);
                    widget.flutterRadioPlayer.setVolume(state.volume);
                  },
                );
              },
            ),
            Icon(
              Icons.volume_up,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget SongHistoryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    scrollable: true,
                    backgroundColor: Colors.black87,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Song History',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                    content: Container()),
              );
            },
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: Text(
              'Song History',
              style: TextStyle(color: Colors.white),
            )),
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
