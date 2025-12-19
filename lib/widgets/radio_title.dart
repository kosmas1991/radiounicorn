import 'dart:async';
import 'package:flutter/material.dart';
import 'package:radiounicorn/mainVars.dart';
import 'package:radiounicorn/models/musicdata.dart';

class RadioTitle extends StatelessWidget {
  const RadioTitle({
    super.key,
    required this.musicData,
  });

  final Future<MusicData> musicData;

  @override
  Widget build(BuildContext context) {
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
                        'listening: ${snapshot.data!.listeners!.unique}',
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
}
