import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButtonAndVolume extends StatefulWidget {
  const PlayButtonAndVolume({
    super.key,
    required this.player,
  });

  final AudioPlayer player;

  @override
  State<PlayButtonAndVolume> createState() => _PlayButtonAndVolumeState();
}

class _PlayButtonAndVolumeState extends State<PlayButtonAndVolume> {
  late double myVolume;

  @override
  Widget build(BuildContext context) {
    myVolume = widget.player.volume;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: widget.player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_circle_outline,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: widget.player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay_outlined,
                  color: Colors.blue,
                ),
                iconSize: 32.0,
                onPressed: () => widget.player.seek(Duration.zero),
              );
            }
          },
        ),
        Row(
          children: [
            Icon(
              Icons.volume_down,
              color: Colors.grey,
            ),
            Slider(
              activeColor: Colors.grey,
              value: myVolume,
              onChanged: (value) {
                setState(() {
                  myVolume = value;
                  widget.player.setVolume(value);
                });
              },
            ),
            Icon(
              Icons.volume_up,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }
}
