import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utterance_search_app/src/models/async_recognition.model.dart';
import 'package:utterance_search_app/src/models/minutes.model.dart';
import 'package:utterance_search_app/src/repositories/recognition_repository.dart';

final uploadControllerProvider =
    AsyncNotifierProvider<UploadController, List<Minutes>>(
        UploadController.new);

class UploadController extends AsyncNotifier<List<Minutes>> {
  List<PlatformFile>? _paths;
  Timer? _timer;

  @override
  FutureOr<List<Minutes>> build() {
    return [];
  }

  Future<void> pick() async {
    state = const AsyncLoading();
    try {
      final paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.audio,
        allowMultiple: true,
      ))
          ?.files;
      _merge(paths);
      await _uploadAll();
      _polling();
    } on PlatformException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _uploadAll() async {
    final repo = ref.watch(recognitionRepositoryProvider);
    final minutesList = state.value ?? [];
    if (minutesList.isEmpty) return;

    for (Minutes minutes in minutesList) {
      _upload(minutes, repo);
    }
  }

  Future<void> _upload(
      Minutes minutes, RecognitionRepository repository) async {
    if (minutes.status != 0 && minutes.status != 4) return;
    final minutesList = state.value ?? [];
    if (minutesList.isEmpty) return;

    final index = minutesList
        .indexWhere((element) => element.audioPath == minutes.audioPath);
    if (index < 0) return;
    final data = await File(minutes.audioPath).readAsBytes();
    state.value![index] = minutes.copyWith(status: 1);
    state = AsyncValue.data(state.value!);

    try {
      final sessionId = await repository.upload(data);
      state.value![index] = minutes.copyWith(
        sessionId: sessionId,
        status: 2,
      );
      state = AsyncValue.data(state.value!);
    } catch (e) {
      state.value![index] = minutes.copyWith(
        status: 4,
        asyncRecognition: AsyncRecognition.error(e.toString()),
      );
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _polling() async {
    if (_timer != null && _timer!.isActive) return;
    void periodicFetch(Timer timer) {
      final minutesList = state.value;
      if (minutesList == null) return;
      final stopPolling = minutesList
          .where(
            (element) => element.status != 3 && element.status != 4,
          )
          .isEmpty;
      if (stopPolling) {
        timer.cancel();
        return;
      }
      _fetchAll();
    }

    _timer = Timer.periodic(const Duration(seconds: 5), periodicFetch);
  }

  Future<void> _fetchAll() async {
    final repo = ref.watch(recognitionRepositoryProvider);
    final minutesList = state.value ?? [];
    if (minutesList.isEmpty) return;

    for (Minutes minutes in minutesList) {
      _fetch(minutes, repo);
    }
  }

  Future<void> _fetch(Minutes minutes, RecognitionRepository repository) async {
    //print("polling[${minutes.asyncRecognition?.status}]: ${minutes.audioPath}");
    final minutesList = state.value ?? [];
    if (minutesList.isEmpty) return;
    final recognition = await repository.fetch(minutes.sessionId);
    final index = minutesList
        .indexWhere((element) => element.sessionId == minutes.sessionId);
    state.value![index] = minutesList[index].copyWith(
      asyncRecognition: recognition,
      status: _convertStatus(recognition.status),
    );
    state = AsyncValue.data(state.value!);
  }

  int _convertStatus(String status) {
    switch (status) {
      case "queued":
      case "started":
      case "processing":
        return 2;
      case "completed":
        return 3;
      case "error":
        return 4;
      default:
        return 0;
    }
  }

  Future<void> reload(Minutes minutes) async {
    final repo = ref.watch(recognitionRepositoryProvider);
    if (minutes.status == 0 || minutes.status == 4) {
      _upload(minutes, repo);
      _polling();
    } else {
      _fetch(minutes, repo);
    }
  }

  Future<void> delete(Minutes minutes) async {
    final minutesList = state.value ?? [];
    if (minutesList.isEmpty) return;
    _paths?.removeWhere((element) {
      return element.path == minutes.audioPath;
    });
    minutesList.removeWhere((element) {
      return element.audioPath == minutes.audioPath;
    });
    state = AsyncData(minutesList);
  }

  List<PlatformFile> _diff(List<PlatformFile>? newPaths) {
    if (newPaths == null || newPaths.isEmpty) return [];
    if (_paths == null) return newPaths;
    List<PlatformFile> list = [];
    for (final newPath in newPaths) {
      final isNewPath = _paths!.indexWhere((element) {
            return (element.size == newPath.size &&
                element.path == newPath.path);
          }) <
          0;
      if (isNewPath == false) continue;
      list.add(newPath);
    }
    return list;
  }

  void _merge(List<PlatformFile>? paths) {
    final newPaths = _diff(paths);
    if (newPaths.isEmpty) {
      state = AsyncData(state.value ?? []);
      return;
    }
    if (_paths == null) {
      _paths = newPaths;
    } else {
      _paths!.addAll(newPaths);
    }

    var tmp = state.value;
    tmp?.addAll(_convert(newPaths));
    if (tmp == null) return;
    state = AsyncValue.data(tmp);
  }

  List<Minutes> _convert(List<PlatformFile>? paths) {
    if (paths == null) return [];
    var list = <Minutes>[];
    for (final file in paths) {
      final path = file.path;
      if (path == null) continue;
      list.add(
        Minutes(audioPath: path),
      );
    }
    return list;
  }
}
