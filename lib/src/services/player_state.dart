class MyPlayerState {
  final Duration progress;
  final Duration total;
  final bool isPlaying;

  MyPlayerState({
    required this.progress,
    required this.total,
    required this.isPlaying,
  });

  factory MyPlayerState.empty() => MyPlayerState(
        progress: const Duration(),
        total: const Duration(),
        isPlaying: false,
      );

  MyPlayerState copyWith({
    Duration? progress,
    Duration? total,
    bool? isPlaying,
  }) {
    return MyPlayerState(
      progress: progress ?? this.progress,
      total: total ?? this.total,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
