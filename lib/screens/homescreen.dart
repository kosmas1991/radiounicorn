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
        ]),
      ),
    );
  }
}
