import 'package:flutter/material.dart';

class MyIconButton extends IconButton {
  const MyIconButton(
      {super.key, required super.onPressed, required super.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: IconButton(
        padding: const EdgeInsets.all(1),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        iconSize: 15,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
