import 'package:flutter/material.dart';

class CustomAddButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final double height;
  final double width;
  final Icon icon;
  const CustomAddButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(fixedSize: Size(width, height)),
      icon: icon,
      label: Text(
        buttonText,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
