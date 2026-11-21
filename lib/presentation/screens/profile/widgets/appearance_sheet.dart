import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/app_theme_mode.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/screens/profile/widgets/theme_option_card.dart';

class AppearanceSheet extends StatelessWidget {
  const AppearanceSheet({super.key});

  static Future<void> show(BuildContext context) {
    final controller = context.read<SettingsController>();

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ChangeNotifierProvider<SettingsController>.value(
        value: controller,
        child: const AppearanceSheet(),
      ),
    );
  }

  static const _options = [
    (AppThemeMode.system, 'System', AppAssets.systemModeImage),
    (AppThemeMode.light, 'Light', AppAssets.lightModeImage),
    (AppThemeMode.dark, 'Dark', AppAssets.darkModeImage),
  ];

  Future<void> _select(BuildContext context, AppThemeMode mode) async {
    final navigator = Navigator.of(context);

    await context.read<SettingsController>().changeTheme(mode);

    if (navigator.mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = context.watch<SettingsController>().themeMode;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: theme.textTheme.titleLarge),
            SizedBox(height: AppSizes.s8),
            Text(
              'Follow your device or choose a theme.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: AppSizes.s20),
            Row(
              children: [
                for (final option in _options) ...[
                  Expanded(
                    child: ThemeOptionCard(
                      title: option.$2,
                      image: option.$3,
                      selected: current == option.$1,
                      onTap: () => _select(context, option.$1),
                    ),
                  ),
                  if (option != _options.last) SizedBox(width: AppSizes.s12),
                ],
              ],
            ),
            SizedBox(height: AppSizes.s12),
          ],
        ),
      ),
    );
  }
}
