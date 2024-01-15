import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:radiounicorn/cubits/filteredlist/filteredlist_cubit.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:radiounicorn/models/requestsongdata.dart';
import '../strings.darthidden';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class Player extends StatefulWidget {
  final BuildContext snackBarContext;
  const Player({required this.snackBarContext, super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  double volume = 1;
  TextEditingController textEditingController = TextEditingController();
  late Future<MusicData> musicData;
  late Future<List<NextSongsData>> nextSongsData;
  late Future<List<RequestSongData>> reqData;
  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer.open(
        Audio.liveStream('https://radiounicorn.eu/listen/unicorn/radio.mp3'),
        autoStart: false,
        playInBackground: PlayInBackground.enabled,
        volume: 1,
        showNotification: true);
    musicData = fetching();
    nextSongsData = fetchingNextSongs();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        musicData = fetching();
        nextSongsData = fetchingNextSongs();
      });
    });
    reqData = fetchSongRequestList();
    reqData.then(
        (value) => context.read<RequestsonglistCubit>().emitNewList(value));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 450,
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
              SongHistoryAndRequestSongButtons(),
            ],
          )),
    );
  }

  Widget RadioTitle() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'radio unicorn',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: musicData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 10,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'listening now: ${snapshot.data!.listeners!.current}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
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
                      width: 300,
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
                    Container(
                      width: 300,
                      child: Text(
                        '${snapshot.data!.nowPlaying!.song!.artist}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        softWrap: false,
                      ),
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
          ),
          Icon(
            Icons.volume_up,
            color: Colors.grey,
            size: 20,
          ),
        ]),
      ],
    );
  }

  Widget SongHistoryAndRequestSongButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 350,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.spaceBetween,
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
                                width: 400,
                                height: screenHeight * 5 / 9,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.songHistory!.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 20,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  '${snapshot.data!.songHistory![index].song!.title}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  '${snapshot.data!.songHistory![index].song!.artist}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
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
                            'Request Song',
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
                            onPressed: () {
                              textEditingController.text = '';
                              context
                                  .read<SearchstringCubit>()
                                  .emitNewSearch('');
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      content: Container(
                        width: 400,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: textEditingController,
                                onChanged: (value) {
                                  textEditingController.text = value;
                                  context
                                      .read<SearchstringCubit>()
                                      .emitNewSearch(value);
                                },
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                maxLines: 1,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                    hintText: 'Search a song or artist ...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                                flex: 9,
                                child: BlocBuilder<FilteredlistCubit,
                                    FilteredlistState>(
                                  builder: (context1, state) {
                                    return Container(
                                      width: screenWidth * 8 / 9,
                                      height: screenHeight * 8 / 9,
                                      child: ListView.builder(
                                        itemCount: state.filteredList.length,
                                        itemBuilder: (context2, index) =>
                                            Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                requestNewSong(
                                                    state.filteredList[index]
                                                        .requestUrl!,
                                                    widget.snackBarContext);
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      (index + 1).toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                      placeholder:
                                                          kTransparentImage,
                                                      image:
                                                          '${state.filteredList[index].song!.art}',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: screenWidth *
                                                              1 /
                                                              2.5,
                                                          child: Text(
                                                            '${state.filteredList[index].song!.title}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: screenWidth *
                                                              1 /
                                                              2.5,
                                                          child: Text(
                                                            '${state.filteredList[index].song!.artist}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      )),
                );
              },
              icon: Icon(
                Icons.audiotrack_sharp,
                color: Colors.white,
              ),
              label: Text(
                'Request Song',
                style: TextStyle(color: Colors.white),
              )),
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
                            'Next songs',
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
                      content: Container(
                        width: 400,
                        child: FutureBuilder<List<NextSongsData>>(
                            future: nextSongsData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width: screenWidth * 7 / 9,
                                  height: screenHeight * 2.5 / 9,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
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
                                                    '${snapshot.data![index].song!.art}',
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        screenWidth * 1 / 2.5,
                                                    child: Text(
                                                      '${snapshot.data![index].song!.title}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        screenWidth * 1 / 2.5,
                                                    child: Text(
                                                      '${snapshot.data![index].song!.artist}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                            }),
                      )),
                );
              },
              icon: Icon(
                Icons.skip_next_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Next Songs',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}

Future<MusicData> fetching() async {
  var response =
      await http.get(Uri.parse('https://radiounicorn.eu/api/nowplaying/1'));

  if (response.statusCode == 200) {
    return MusicData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed');
  }
}

Future<List<RequestSongData>> fetchSongRequestList() async {
  var response = await http
      .get(Uri.parse('https://radiounicorn.eu/api/station/1/requests'));

  if (response.statusCode == 200) {
    List<RequestSongData> data = (json.decode(response.body) as List)
        .map((i) => RequestSongData.fromJson(i))
        .toList();
    return data;
  } else {
    throw Exception('Failed');
  }
}

void requestNewSong(String url, BuildContext context) async {
  var response = await http.get(Uri.parse('https://radiounicorn.eu${url}'));
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

Future<List<NextSongsData>> fetchingNextSongs() async {
  final headers = {
    'accept': 'application/json',
    'X-API-Key': '${key}',
  };
  final url = Uri.parse('https://radiounicorn.eu/api/station/1/queue');
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
