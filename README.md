# Speech Recognition Flutter App

音声認識APIであるAmiVoice APIを使い、送信した音声ファイルをテキスト化するFlutterアプリ

## 開発環境
- macOS 12.6
- Flutter 3.19.6
- Xcode 14.2
- テスト環境: macos

<details><summary>pubspec.yaml</summary>

```yaml:pubspec.yaml
name: speech_recognition_flutter_app
description: "A new Flutter project."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.4 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6
  file_picker: ^8.0.3
  http: ^1.2.1
  go_router: ^14.0.2
  hooks_riverpod: ^2.5.1
  intl: ^0.19.0
  just_audio: ^0.9.37
  audio_video_progress_bar: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

</details>

## アプリについて

このアプリは、

1. 音声ファイルを送信し、音声認識が完了するまで待つ
2. 音声認識結果の確認

といった流れで音声ファイルの書き起こしを行います。

## 1. 音声ファイルを送信し、音声認識が完了するまで待つ
![send2comp](https://github.com/mlballack/speech-recognition-app-flutter/assets/77086210/ea241bea-cd6e-4eba-a55a-164c956657d2)

> 注意<br>
見やすさのために音声認識が完了するまで早送りしています。実際には、送信した音声の0.5〜1.5倍ほどの時間が必要なのでご注意ください。([詳しくは"非同期 HTTP インタフェース"の"注記"を参照してください](https://docs.amivoice.com/amivoice-api/manual/))

## 2. 音声認識結果の確認
![result](https://github.com/mlballack/speech-recognition-app-flutter/assets/77086210/23199ffc-79af-44ce-99c9-7afbb0f3793b)


