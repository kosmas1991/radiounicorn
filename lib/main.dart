import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radiounicorn/cubits/filteredlist/filteredlist_cubit.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/mainVars.dart';
import 'package:radiounicorn/screens/homescreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
Flutter 3.29.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 09de023485 (3 weeks ago) • 2025-02-28 13:44:05 -0800
Engine • revision 871f65ac1b
Tools • Dart 3.7.0 • DevTools 2.42.2
*/

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'gr.techzombie.radiounicorn.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // uncomment if you want only portrait mode

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchstringCubit(),
        ),
        BlocProvider(
          create: (context) => RequestsonglistCubit(),
        ),
        BlocProvider(
          create: (context) => FilteredlistCubit(
              initialList: context.read<RequestsonglistCubit>().state.list,
              requestsonglistCubit: context.read<RequestsonglistCubit>(),
              searchstringCubit: context.read<SearchstringCubit>()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: 'radio ${stationName}',
        home: HomeScreen(),
      ),
    );
  }
}
