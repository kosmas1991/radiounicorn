import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radiounicorn/cubits/filteredlist/filteredlist_cubit.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/mainVars.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:radiounicorn/models/requestsongdata.dart';
import '../strings.darthidden';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';

class Player extends StatefulWidget {
  final BuildContext snackBarContext;
  const Player({required this.snackBarContext, super.key});

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
            'radio ${stationName}',
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
                        'listening now: ${snapshot.data!.listeners!.unique}',
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
                        '${utf8.decode(snapshot.data!.nowPlaying!.song!.title!.codeUnits)}',
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
                      width: screenWidth * 5 / 9,
                      child: Text(
                        '${utf8.decode(snapshot.data!.nowPlaying!.song!.artist!.codeUnits)}',
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
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_circle_outline,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay_outlined,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        Row(
          children: [
            Icon(
              Icons.volume_down,
              color: Colors.grey,
            ),
            Slider(
              activeColor: Colors.grey,
              value: volume,
              onChanged: (value) {
                setState(() {
                  volume = value;
                  player.setVolume(value);
                });
                setState(() {
                  volume = value;
                  player.setVolume(value);
                });
              },
            ),
            Icon(
              Icons.volume_up,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }

  Widget SongHistoryAndRequestSongButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Wrap(
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
                          DateTime now = DateTime.now();

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
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${utf8.decode(snapshot.data!.songHistory![index].song!.title!.codeUnits)}',
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
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${utf8.decode(snapshot.data!.songHistory![index].song!.artist!.codeUnits)}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                'before ${(((now.millisecondsSinceEpoch / 1000) - snapshot.data!.songHistory![index].playedAt!) / 60).round()} mins',
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
                            context.read<SearchstringCubit>().emitNewSearch('');
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    content: Column(
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                                    itemBuilder: (context2, index) => Column(
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
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image:
                                                      '${state.filteredList[index].song!.art}',
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
                                                    width:
                                                        screenWidth * 1 / 2.5,
                                                    child: Text(
                                                      '${state.filteredList[index].song!.title}',
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
                                                      '${state.filteredList[index].song!.artist}',
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
                    content: FutureBuilder<List<NextSongsData>>(
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${utf8.decode(snapshot.data![index].song!.title!.codeUnits)}',
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
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${utf8.decode(snapshot.data![index].song!.artist!.codeUnits)}',
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
              Icons.skip_next_outlined,
              color: Colors.white,
            ),
            label: Text(
              'Next Songs',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}

Future<MusicData> fetching() async {
  var response =
      await http.get(Uri.parse('${theURL}/api/nowplaying/${theStationID}'));

  if (response.statusCode == 200) {
    return MusicData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed');
  }
}

Future<List<RequestSongData>> fetchSongRequestList() async {
  var response = await http
      .get(Uri.parse('${theURL}/api/station/${theStationID}/requests'));

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
  var response = await http.get(Uri.parse('${theURL}${url}'));
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
  final url = Uri.parse('${theURL}/api/station/${theStationID}/queue');
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
