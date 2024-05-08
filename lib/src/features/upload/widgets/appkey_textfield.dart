import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppkeyTextfield extends HookConsumerWidget {
  final void Function(String)? onChangedText;
  final _textEditingController = useTextEditingController();

  AppkeyTextfield({
    super.key,
    this.onChangedText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscure = useState(true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        obscureText: isObscure.value,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          labelText: "APPKEYを設定",
          labelStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: const OutlineInputBorder(
            // 角丸
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: const OutlineInputBorder(
            // 角丸
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          suffixIcon: IconButton(
            iconSize: 14,
            onPressed: () {
              isObscure.value = !isObscure.value;
            },
            icon: Icon(isObscure.value
                ? CupertinoIcons.eye_slash
                : CupertinoIcons.eye),
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        cursorHeight: 17,
        cursorColor: Colors.grey.shade400,
        textAlign: TextAlign.left,
        controller: _textEditingController,
        onChanged: onChangedText,
      ),
    );
  }
}
