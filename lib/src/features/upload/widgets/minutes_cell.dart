import 'package:flutter/material.dart';
import 'package:utterance_search_app/src/features/upload/widgets/my_icon_button.dart';
import 'package:utterance_search_app/src/models/minutes.model.dart';

class MinutesCell extends StatelessWidget {
  final Minutes minutes;
  final void Function()? onReload;
  final void Function()? onDelete;

  const MinutesCell({
    super.key,
    required this.minutes,
    this.onReload,
    this.onDelete,
  });

  String get _fileName {
    return minutes.audioPath.split("/").last;
  }

  String get _path {
    final splited = minutes.audioPath.split("/");
    splited.removeLast();
    return "${splited.join("/")}/";
  }

  /// status:
  /// - 0 -> 音声ファイルを未送信
  /// - 1 -> 音声ファイルを送信中
  /// - 2 -> 音声認識の処理中
  /// - 3 -> 音声認識が完了
  /// - 4 -> なんらかの理由で音声認識に失敗した
  int get _progress {
    return minutes.status;
  }

  String get _progressText {
    switch (_progress) {
      case 0:
        return "未送信";
      case 1:
        return "送信中";
      case 2:
        return "処理中";
      case 3:
        return "完了";
      case 4:
        return "エラー";
      default:
        return "未送信";
    }
  }

  Color get _progressColor {
    switch (_progress) {
      case 0:
      case 1:
      case 2:
        return Colors.grey;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get _errorMessage {
    return minutes.asyncRecognition?.errorMessage ?? "音声認識に失敗しました。";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        //color: Colors.grey.shade300, //Color.fromARGB(1, 242, 242, 247),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: _progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _progressText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _path,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    _fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (_progress == 4)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.report_gmailerrorred,
                        color: _progressColor,
                        size: 18,
                      ),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: _progressColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (_progress == 0 || _progress == 3 || _progress == 4)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (_progress != 3)
                      MyIconButton(
                        onPressed: onReload,
                        icon: Icon(
                          Icons.replay_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    const SizedBox(
                      width: 2,
                    ),
                    MyIconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
