import 'package:flutter/material.dart';

class CutomTextFormField extends StatelessWidget {
  // here I will Create Var
  final String hintText;
  final String validatorText;
  final TextEditingController myController;
  final int? maxLines;
  final String titleText;

  const CutomTextFormField({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.myController,
    required this.validatorText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: 18),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 8),
        TextFormField(
          style: Theme.of(context).textTheme.labelMedium,
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return validatorText;
            }
            return null;
          },
          maxLines: maxLines,
          controller: myController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
