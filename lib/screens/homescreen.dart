import 'package:flutter/material.dart';
import 'package:radiounicorn/widgets/player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child:
                  Image.asset('assets/images/azulogo.png', fit: BoxFit.cover)),
          Player(),
        ]),
      ),
    );
  }
}
