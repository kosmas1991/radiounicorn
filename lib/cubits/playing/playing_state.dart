part of 'playing_cubit.dart';

class PlayingState extends Equatable {
  final bool playing;

  PlayingState({required this.playing});

  factory PlayingState.initial() {
    return PlayingState(playing: true);
  }

  @override
  List<Object> get props => [playing];

  PlayingState copyWith({
    bool? playing,
  }) {
    return PlayingState(
      playing: playing ?? this.playing,
    );
  }

  @override
  bool get stringify => true;
}
