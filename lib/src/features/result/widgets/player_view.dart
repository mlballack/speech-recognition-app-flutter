import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_recognition_flutter_app/src/services/player_controller.dart';

class PlayerView extends HookConsumerWidget {
  final void Function() onPlay;
  final void Function() onPause;
  final void Function(Duration) onSeek;

  const PlayerView({
    super.key,
    required this.onPlay,
    required this.onPause,
    required this.onSeek,
  });

  Widget _progressBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPlayerControllerProvider);
    switch (state) {
      case AsyncData(:final value):
        return Column(
          children: [
            ProgressBar(
              progress: value.progress,
              total: value.total,
              timeLabelLocation: TimeLabelLocation.sides,
              progressBarColor: Colors.grey.shade700,
              baseBarColor: Colors.grey.shade300,
              thumbColor: Colors.grey.shade800,
              thumbRadius: 6,
              thumbGlowRadius: 7,
              timeLabelTextStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              onSeek: (value) {
                onSeek(value);
              },
            ),
            IconButton(
              onPressed: () {
                if (value.isPlaying == false) {
                  onPlay();
                } else {
                  onPause();
                }
              },
              icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 14, right: 14, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: _progressBar(context, ref),
    );
  }
}
