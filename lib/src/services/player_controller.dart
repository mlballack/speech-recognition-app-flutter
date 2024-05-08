import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:utterance_search_app/src/services/player_state.dart';

final myPlayerControllerProvider =
    AsyncNotifierProvider.autoDispose<MyPlayerController, MyPlayerState>(
        MyPlayerController.new);

class MyPlayerController extends AutoDisposeAsyncNotifier<MyPlayerState> {
  final _player = AudioPlayer();

  @override
  FutureOr<MyPlayerState> build() async {
    _player.positionStream.listen((event) {
      state = AsyncValue.data(state.value!.copyWith(progress: event));
    });
    _player.playerStateStream.listen((event) {
      state = AsyncValue.data(state.value!.copyWith(
          isPlaying: event.playing &&
              event.processingState != ProcessingState.completed));

      if (event.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.stop();
      }
    });
    return MyPlayerState.empty();
  }

  Future<void> setup(String filePath) async {
    if (filePath.isEmpty) return;
    final duration = await _player.setFilePath(// Load a URL
        filePath);
    state = AsyncValue.data(
        state.value!.copyWith(total: duration ?? const Duration()));
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
