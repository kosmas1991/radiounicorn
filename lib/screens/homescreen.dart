import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:radiounicorn/widgets/player.dart';

class HomeScreen extends StatelessWidget {
  final FlutterRadioPlayer flutterRadioPlayer;
  const HomeScreen({required this.flutterRadioPlayer, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child:
                  Image.asset('assets/images/azulogo.png', fit: BoxFit.fill)),
          Player(
            flutterRadioPlayer: flutterRadioPlayer,
          )
          // Center(
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Colors.black26,
          //         borderRadius: BorderRadius.circular(10)),
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Text(
          //               'radio unicorn',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 25,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //         Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Flexible(
          //                 flex: 2,
          //                 child: BlocBuilder<PlayingCubit, PlayingState>(
          //                   builder: (context, state) {
          //                     return IconButton(
          //                         onPressed: () {
          //                           widget.flutterRadioPlayer.playOrPause();
          //                         },
          //                         icon: Icon(
          //                           state.playing == true
          //                               ? Icons.pause_circle_outline
          //                               : Icons.play_circle_outline,
          //                           size: 50,
          //                           color: Colors.blue,
          //                         ));
          //                   },
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 1,
          //                 child: FutureBuilder<MusicData>(
          //                   future: musicData,
          //                   builder: (context, snapshot) {
          //                     if (snapshot.hasData) {
          //                       return FadeInImage.memoryNetwork(
          //                         placeholder: kTransparentImage,
          //                         image:
          //                             '${snapshot.data!.nowPlaying!.song!.art}',
          //                       );
          //                     } else {
          //                       return Container();
          //                     }
          //                   },
          //                 ),
          //               )
          //             ]),
          //       ],
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }
}
