import 'package:flutter/material.dart';

class ClearDataDialog extends StatelessWidget {
  const ClearDataDialog({super.key});

  /// Resolves to true only when the user confirmed.
  static Future<bool> confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ClearDataDialog(),
    );

    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clear all data?'),
      content: const Text(
        'This will permanently remove all tasks and your profile. '
        'App preferences will remain.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Clear all data'),
        ),
      ],
    );
  }
}
