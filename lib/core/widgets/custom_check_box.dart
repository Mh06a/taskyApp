import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  //step1 ---- Create vars for class :
  final bool value;
  final Function(bool?) onChanged;
  final Color? activeColor;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
