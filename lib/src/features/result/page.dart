import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utterance_search_app/src/features/result/widgets/player_view.dart';
import 'package:utterance_search_app/src/features/result/widgets/result_cell.dart';
import 'package:utterance_search_app/src/models/async_recognition.model.dart';
import 'package:utterance_search_app/src/models/minutes.model.dart';
import 'package:utterance_search_app/src/services/player_controller.dart';
import 'package:utterance_search_app/src/widgets/cell_button.dart';

class ResultPage extends HookConsumerWidget {
  static ResultPage builder(BuildContext context, GoRouterState state) {
    return ResultPage(
      minutes: state.extra as Minutes,
    );
  }

  final Minutes minutes;
  String get fileName {
    return minutes.audioPath.split("/").last;
  }

  List<Segment> get _segments {
    return minutes.asyncRecognition?.segments ?? [];
  }

  const ResultPage({
    super.key,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.watch(myPlayerControllerProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        playerController.setup(minutes.audioPath);
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "$fileNameの認識結果",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: PlayerView(
              onPlay: () {
                playerController.play();
              },
              onPause: () {
                playerController.pause();
              },
              onSeek: (value) {
                playerController.seek(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._segments.map((Segment segment) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Column(
                        children: [
                          CellButton(
                            child: ResultCell(segment: segment),
                            onPressed: () {
                              final result = segment.results.first;
                              final position =
                                  Duration(milliseconds: result.startTime ?? 0);
                              playerController.seek(position);
                            },
                          ),
                          if (_segments.last != segment)
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 5, left: 25, bottom: 5, right: 15),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.05,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
