import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'playing_state.dart';

class PlayingCubit extends Cubit<PlayingState> {
  late final StreamSubscription playStreamSubscription;

  PlayingCubit()
      : super(PlayingState.initial()) {

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
