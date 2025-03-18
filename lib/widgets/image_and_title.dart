import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radiounicorn/models/musicdata.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageAndTitle extends StatelessWidget {
  const ImageAndTitle({
    super.key,
    required this.context,
    required this.musicData,
  });

  final BuildContext context;
  final Future<MusicData> musicData;

  @override
  Widget build(BuildContext context) {
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
}
