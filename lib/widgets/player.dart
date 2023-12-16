import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  double volume = 0.5;
  late Future<MusicData> musicData;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer.open(
        Audio.liveStream('https://radiounicorn.eu/listen/unicorn/radio.mp3'),
        autoStart: true,
        playInBackground: PlayInBackground.enabled,
        volume: 1,
        showNotification: true);
    musicData = fetching();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 15), (timer) {
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
                      width: screenWidth * 5 / 9,
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
        IconButton(
            onPressed: () {
              _assetsAudioPlayer.playOrPause();
            },
            icon: PlayerBuilder.isPlaying(
                player: _assetsAudioPlayer,
                builder: (context, isPlaying) => isPlaying
                    ? Icon(
                        Icons.pause_circle_outline,
                        size: 40,
                        color: Colors.blue,
                      )
                    : Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: Colors.blue,
                      ))),
        Row(children: [
          Icon(
            Icons.volume_mute,
            color: Colors.grey,
            size: 20,
          ),
          PlayerBuilder.volume(
            player: _assetsAudioPlayer,
            builder: (context, volume) => Slider(
              activeColor: Colors.grey,
              value: volume,
              onChanged: (value) {
                _assetsAudioPlayer.setVolume(value);
              },
            ),
          )
        ]),
        Icon(
          Icons.volume_up,
          color: Colors.grey,
          size: 20,
        ),
      ],
    );
  }

  Widget SongHistoryButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    backgroundColor: Color.fromARGB(255, 42, 42, 42),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Song History',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    content: FutureBuilder<MusicData>(
                        future: musicData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: screenWidth * 7 / 9,
                              height: screenHeight * 5 / 9,
                              child: ListView.builder(
                                itemCount: snapshot.data!.songHistory!.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                '${snapshot.data!.songHistory![index].song!.art}',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${snapshot.data!.songHistory![index].song!.title}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.blue,
                            ));
                          }
                        })),
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
    List<MusicData> musicDatas;
    musicDatas = (json.decode(response.body) as List)
        .map((i) => MusicData.fromJson(i))
        .toList();
    return musicDatas[0]; // first radio
  } else {
    throw Exception('Failed');
  }
}
