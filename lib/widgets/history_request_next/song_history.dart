import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:transparent_image/transparent_image.dart';

class songHistory extends StatelessWidget {
  const songHistory({
    super.key,
    required this.musicData,
    required this.screenWidth,
    required this.screenHeight,
  });

  final Future<MusicData> musicData;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                              fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
