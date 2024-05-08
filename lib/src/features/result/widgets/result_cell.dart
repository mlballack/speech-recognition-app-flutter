import 'package:flutter/material.dart';
import 'package:utterance_search_app/src/models/async_recognition.model.dart';
import 'package:utterance_search_app/src/models/recognition.model.dart';

class ResultCell extends StatelessWidget {
  final Segment segment;
  SRResult get _result {
    return segment.results.first;
  }

  const ResultCell({super.key, required this.segment});
  String _convertTime(int? millisec) {
    String convert(int time) {
      return time.toString().padLeft(2, "0");
    }

    final int startTime = (millisec == null) ? 0 : (millisec * 0.001).toInt();
    var hour = (startTime / 3600).floor();
    var mod = startTime % 3600;
    var minutes = (mod / 60).floor();
    var second = mod % 60;
    if (hour > 0) {
      return "${convert(hour)}:${convert(minutes)}:${convert(second)}";
    } else {
      return "${convert(minutes)}:${convert(second)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 0, bottom: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 3),
            width: 65,
            child: Text(
              _convertTime(_result.startTime),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(segment.text),
          ),
        ],
      ),
    );
  }
}
