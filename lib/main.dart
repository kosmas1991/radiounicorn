import 'package:flutter/material.dart';
import 'package:radiounicorn/cubits/filteredlist/filteredlist_cubit.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/screens/homescreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: 'radio unicorn',
        home: HomeScreen(),
      ),
    );
  }
}
