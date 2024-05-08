import './recognition.model.dart';

class AsyncRecognition {
  final String status; // State of job.
  final String audioMd5; // 受信した音声ファイルの MD5 チェックサムの値
  final int? audioSize;
  final String contentId; // ユーザがリクエスト時に設定した contentId の値
  final String serviceId; // ユーザー名
  final List<Segment> segments; // 音声認識プロセスの結果
  final String utteranceId;
  final String text;
  final String code;
  final String message;
  final String errorMessage;

  const AsyncRecognition({
    required this.status,
    required this.audioMd5,
    this.audioSize,
    required this.contentId,
    required this.serviceId,
    required this.segments,
    required this.utteranceId,
    required this.text,
    required this.code,
    required this.message,
    required this.errorMessage,
  });

  factory AsyncRecognition.fromJson(dynamic json) {
    List<Segment> toSegments(dynamic segments) {
      if (segments == null) return [];
      return (segments as List<dynamic>)
          .map((e) => Segment.fromJson(e))
          .toList();
    }

    return AsyncRecognition(
      status: json["status"] ?? "error",
      audioMd5: json["audio_md5"] ?? "",
      audioSize: json["audio_size"],
      contentId: json["content_id"] ?? "",
      serviceId: json["service_id"] ?? "",
      segments: toSegments(json["segments"]),
      utteranceId: json["utteranceid"] ?? "",
      text: json["text"] ?? "",
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      errorMessage: json["error_message"] ?? "",
    );
  }

  factory AsyncRecognition.error(String errorMessage) {
    return AsyncRecognition(
      status: "",
      audioMd5: "",
      contentId: "",
      serviceId: "",
      segments: [],
      utteranceId: "",
      text: "",
      code: "",
      message: "",
      errorMessage: errorMessage,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "audioMd5": audioMd5,
      "audioSize": audioSize,
      "contentId": contentId,
      "serviceId": serviceId,
      "segments": segments,
      "utteranceId": utteranceId,
      "text": text,
      "code": code,
      "message": message,
      "errorMessage": errorMessage,
    };
  }

  @override
  String toString() {
    return """
    AsyncRecognition(status: $status, audio_md5: $audioMd5, audio_size: $audioSize, content_id: $contentId, service_id: $serviceId, segments: $segments, utteranceId: $utteranceId, text: $text, code: $code, message: $message, error_message: $errorMessage)
    """;
  }
}

class Segment {
  final List<SRResult> results; // 音声認識プロセスの結果
  final String text;
  const Segment({
    required this.results,
    required this.text,
  });

  factory Segment.fromJson(dynamic json) {
    List<SRResult> toSRResults(dynamic results) {
      if (results == null) return [];
      return (results as List<dynamic>)
          .map((e) => SRResult.fromJson(e))
          .toList();
    }

    return Segment(
      results: toSRResults(json["results"]),
      text: json["text"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "results": results,
      "text": text,
    };
  }

  @override
  String toString() {
    return "Segment(results: $results, text: $text)";
  }
}
