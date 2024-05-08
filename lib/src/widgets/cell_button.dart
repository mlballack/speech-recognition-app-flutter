import 'package:flutter/material.dart';

class CellButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const CellButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: const MaterialStatePropertyAll(
          Colors.black,
        ),
        overlayColor: MaterialStatePropertyAll(
          Colors.grey.shade200,
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.all(0),
        ),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
