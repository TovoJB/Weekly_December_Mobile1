import 'package:flutter/material.dart';

// Round outline button
class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressedCallBack;

  const RoundButton({
    Key? key,
    required this.text,
    required this.onPressedCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(100, 100),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
        shape: const CircleBorder(),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      onPressed: onPressedCallBack,
    );
  }
}
