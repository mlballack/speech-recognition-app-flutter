import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utterance_search_app/src/features/upload/controller.dart';
import 'package:utterance_search_app/src/features/upload/widgets/appkey_textfield.dart';
import 'package:utterance_search_app/src/features/upload/widgets/minutes_cell.dart';
import 'package:utterance_search_app/src/models/minutes.model.dart';
import 'package:utterance_search_app/src/repositories/recognition_repository.dart';
import 'package:utterance_search_app/src/routing/locations.dart';
import 'package:utterance_search_app/src/widgets/cell_button.dart';

class UploadPage extends HookConsumerWidget {
  static UploadPage builder(BuildContext context, GoRouterState state) {
    return const UploadPage();
  }

  const UploadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadControllerProvider);
    final controller = ref.watch(uploadControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "音声認識アプリ",
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AmiVoice APIのAPPKEYを入力してください",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              AppkeyTextfield(
                onChangedText: (String text) {
                  ref.watch(recognitionRepositoryProvider).apiKey = text;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(thickness: 0.2),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => controller.pick(),
                      label: const Text('音声データを選択する'),
                      icon: const Icon(Icons.description),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (state.value != null)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...state.value!.map(
                          (Minutes minutes) {
                            final hasResult = minutes.status == 3;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Column(
                                children: [
                                  CellButton(
                                    onPressed: hasResult == false
                                        ? null
                                        : () {
                                            context.go(
                                              "/${RouteLocation.result}",
                                              extra: minutes,
                                            );
                                          },
                                    child: MinutesCell(
                                      minutes: minutes,
                                      onReload: () {
                                        controller.reload(minutes);
                                      },
                                      onDelete: () {
                                        controller.delete(minutes);
                                      },
                                    ),
                                  ),
                                  if (state.value!.last != minutes)
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.05,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (state.isLoading)
            Container(
              color: Colors.grey.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
