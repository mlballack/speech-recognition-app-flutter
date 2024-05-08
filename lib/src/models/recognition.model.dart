class SRResult {
  // Speech Recognition Result
  final List<Token> tokens;
  final double? confidence;
  final int? startTime;
  final int? endTime;
  final List<String> tags;
  final String ruleName;
  final String text;

  const SRResult({
    required this.tokens,
    this.confidence,
    this.startTime,
    this.endTime,
    required this.tags,
    required this.ruleName,
    required this.text,
  });

  factory SRResult.fromJson(dynamic json) {
    List<Token> toTokens(dynamic tokens) {
      if (tokens == null) return [];
      return (tokens as List<dynamic>).map((e) => Token.fromJson(e)).toList();
    }

    List<String> toTags(dynamic tags) {
      if (tags == null) return [];
      return (tags as List<dynamic>).map((e) => e as String).toList();
    }

    double toConfidence(dynamic data) {
      if (data is int) {
        return data.toDouble();
      } else if (data is double) {
        return data;
      }
      return 0.0;
    }

    return SRResult(
      tokens: toTokens(json["tokens"]),
      confidence: toConfidence(json["confidence"]),
      startTime: json["starttime"],
      endTime: json["endtime"],
      tags: toTags(json["tags"]),
      ruleName: json["rulename"] ?? "",
      text: json["text"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tokens": tokens,
      "confidence": confidence,
      "starttime": startTime,
      "endtime": endTime,
      "tags": tags,
      "ruleName": ruleName,
      "text": text,
    };
  }

  @override
  String toString() {
    return "SSResult(tokens: ${tokens.toString()}, confidence: $confidence, starttime: $startTime, endtime: $endTime, tags: $tags, rulename: $ruleName, text: $text)";
  }
}

class Token {
  final String written;
  final double? confidence;
  final int? startTime;
  final int? endTime;
  final String spoken;
  final String label;

  const Token({
    required this.written,
    this.confidence,
    this.startTime,
    this.endTime,
    required this.spoken,
    required this.label,
  });

  factory Token.fromJson(dynamic json) {
    double toConfidence(dynamic data) {
      if (data is int) {
        return data.toDouble();
      } else if (data is double) {
        return data;
      }
      return 0.0;
    }

    return Token(
      written: json["written"] ?? "",
      confidence: toConfidence(json["confidence"]),
      startTime: json["starttime"],
      endTime: json["endtime"],
      spoken: json["spoken"] ?? "",
      label: json["label"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "written": written,
      "confidence": confidence,
      "starttime": startTime,
      "endtime": endTime,
      "spoken": spoken,
      "label": label,
    };
  }

  @override
  String toString() {
    return "Token(written: $written, confidence: $confidence, starttime: $startTime, endtime: $endTime, spoken: $spoken, label: $label)";
  }
}
