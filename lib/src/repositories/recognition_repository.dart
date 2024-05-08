import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:convert';

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:utterance_search_app/src/models/async_recognition.model.dart';

final recognitionRepositoryProvider =
    Provider((ref) => RecognitionRepository());

class RecognitionRepository {
  String apiKey = "";
  final String serverPath =
      'https://acp-api-async.amivoice.com/v1/recognitions';

  Future<String> upload(Uint8List data) async {
    final audioData = data;
    final url = Uri.parse(serverPath);
    final request = http.MultipartRequest("POST", url);
    request.headers["Content-type"] = "multipart/form-data; charset=UTF-8";
    request.fields["u"] = apiKey;
    request.fields["d"] = "grammarFileNames=-a-general";
    request.files.add(http.MultipartFile.fromBytes(
      "a",
      audioData.toList(),
      contentType: MediaType.parse("application/octet-stream"),
    ));

    try {
      final stream = await request.send();
      final response = await http.Response.fromStream(stream);
      final body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      final errorCode = jsonData["code"];
      final errorMessage = jsonData["message"];
      if (errorCode != null && errorMessage != null) {
        throw "$errorMessage[$errorCode]";
      }
      return jsonData["sessionid"] ?? "";
    } catch (e) {
      rethrow;
    }
  }

  Future<AsyncRecognition> fetch(String sessionId) async {
    final url = Uri.parse("$serverPath/$sessionId");
    final request = http.Request("GET", url);
    request.headers["Authorization"] = "Bearer $apiKey";

    try {
      final stream = await request.send();
      final response = await http.Response.fromStream(stream);
      final body = utf8.decode(response.bodyBytes);

      final jsonData = json.decode(body);
      return AsyncRecognition.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }
}


