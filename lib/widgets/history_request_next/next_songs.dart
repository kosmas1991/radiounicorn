import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radiounicorn/models/nextsongsdata.dart';
import 'package:transparent_image/transparent_image.dart';

class NextSongs extends StatelessWidget {
  const NextSongs({
    super.key,
    required this.nextSongsData,
    required this.screenWidth,
    required this.screenHeight,
  });

  final Future<List<NextSongsData>> nextSongsData;
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
                                              fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
