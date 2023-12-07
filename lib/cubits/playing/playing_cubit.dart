import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

part 'playing_state.dart';

class PlayingCubit extends Cubit<PlayingState> {
  late final StreamSubscription playStreamSubscription;
  final FlutterRadioPlayer flutterRadioPlayer;
  PlayingCubit({required this.flutterRadioPlayer})
      : super(PlayingState.initial()) {
    playStreamSubscription = flutterRadioPlayer.frpEventStream!.listen((event) {
      if (event!.contains('playing')) {
        emit(state.copyWith(playing: true));
      }else if(event.contains('loading')){
        emit(state.copyWith(playing: true));
      } else {
        emit(state.copyWith(playing: false));
      }
    });
  }

  emitNewState(bool newState) {
    emit(state.copyWith(playing: newState));
  }

  @override
  Future<void> close() {
    playStreamSubscription.cancel();
    return super.close();
  }
}
