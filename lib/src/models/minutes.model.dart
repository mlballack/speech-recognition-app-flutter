import 'package:utterance_search_app/src/models/async_recognition.model.dart';

class Minutes {
  final String audioPath;
  final String sessionId;

  /// status:
  /// - 0 -> 音声ファイルを未送信
  /// - 1 -> 音声ファイルを送信中
  /// - 2 -> 音声認識の処理中
  /// - 3 -> 音声認識が完了
  /// - 4 -> なんらかの理由で音声認識に失敗した
  final int status;
  final AsyncRecognition? asyncRecognition;

  Minutes({
    required this.audioPath,
    this.status = 0,
    this.sessionId = "",
    this.asyncRecognition,
  });

  Minutes copyWith({
    String? audioPath,
    int? status,
    String? sessionId,
    AsyncRecognition? asyncRecognition,
  }) {
    return Minutes(
      audioPath: audioPath ?? this.audioPath,
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      asyncRecognition: asyncRecognition ?? this.asyncRecognition,
    );
  }
}
