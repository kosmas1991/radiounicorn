import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:radiounicorn/cubits/playing/playing_cubit.dart';
import 'package:radiounicorn/screens/homescreen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    FlutterRadioPlayer flutterRadioPlayer = FlutterRadioPlayer();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PlayingCubit(flutterRadioPlayer: flutterRadioPlayer),
        ),
      ],
      child: MaterialApp(
        title: 'radio unicorn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(flutterRadioPlayer: flutterRadioPlayer),
      ),
    );
  }
}
