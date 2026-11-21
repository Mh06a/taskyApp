import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/app_language.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/screens/profile/widgets/choice_tile.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  static Future<void> show(BuildContext context) {
    final controller = context.read<SettingsController>();

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ChangeNotifierProvider<SettingsController>.value(
        value: controller,
        child: const LanguageSheet(),
      ),
    );
  }

  static const _options = [
    (AppLanguage.system, 'System default'),
    (AppLanguage.english, 'English'),
    (AppLanguage.arabic, 'العربية'),
  ];

  Future<void> _select(BuildContext context, AppLanguage language) async {
    final navigator = Navigator.of(context);

    await context.read<SettingsController>().changeLanguage(language);

    if (navigator.mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = context.watch<SettingsController>().language;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language', style: theme.textTheme.titleLarge),
            SizedBox(height: AppSizes.s8),
            Text(
              'Switch direction with your language.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: AppSizes.s16),
            for (final option in _options)
              ChoiceTile(
                title: option.$2,
                selected: current == option.$1,
                onTap: () => _select(context, option.$1),
              ),
          ],
        ),
      ),
    );
  }
}
