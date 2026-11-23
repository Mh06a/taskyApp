import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_info.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/app_language.dart';
import 'package:tasky/core/enums/app_theme_mode.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/screens/profile/widgets/appearance_sheet.dart';
import 'package:tasky/presentation/screens/profile/widgets/clear_data_dialog.dart';
import 'package:tasky/presentation/screens/profile/widgets/language_sheet.dart';
import 'package:tasky/presentation/screens/profile/widgets/profile_summary_card.dart';
import 'package:tasky/presentation/screens/profile/widgets/settings_tile.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<ProfileController, SettingsController>(
      builder: (context, profileController, settingsController, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.s20,
                AppSizes.s20,
                AppSizes.s20,
                AppSizes.s28,
              ),
              children: [
                Text(
                  'Your space',
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: AppSizes.s20),
                ProfileSummaryCard(
                  displayName: profileController.displayName,
                  profile: profileController.profile,
                ),
                SizedBox(height: AppSizes.s8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.editProfile);
                  },
                  child: const Text('Edit profile'),
                ),
                SizedBox(height: AppSizes.s20),
                Text(
                  'Preferences',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  leading: const AppSvgIcon(
                    assetPath: AppAssets.moonIcon,
                  ),
                  title: 'Theme',
                  subtitle: _themeLabel(settingsController.themeMode),
                  onTap: () => AppearanceSheet.show(context),
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  leading: const AppSvgIcon(
                    assetPath: AppAssets.languageIcon,
                  ),
                  title: 'Language',
                  subtitle: _languageLabel(settingsController.language),
                  onTap: () => LanguageSheet.show(context),
                ),
                SizedBox(height: AppSizes.s24),
                Text(
                  'Your data',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  icon: Icons.storage_outlined,
                  title: 'Offline by design',
                  subtitle: 'Your tasks live only on this device.',
                  onTap: () => _showAbout(
                    context,
                    'Your tasks and profile are stored locally on this device.',
                  ),
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Contact support',
                  subtitle: AppInfo.supportEmail,
                  onTap: () => _contactSupport(context),
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About ${AppInfo.name}',
                  subtitle: 'Version ${AppInfo.version}',
                  onTap: () => _showAbout(
                    context,
                    'A little focus. A lighter day.',
                  ),
                ),
                SizedBox(height: AppSizes.s8),
                SettingsTile(
                  leading: const AppSvgIcon(
                    assetPath: AppAssets.recycleBinIcon,
                  ),
                  title: 'Clear all data',
                  subtitle: 'Remove tasks and profile from this device',
                  onTap: () => _clearAllData(context),
                ),
                SizedBox(height: AppSizes.s20),
                Center(
                  child: Text(
                    '${AppInfo.name} · A little focus. A lighter day.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAbout(BuildContext context, String message) {
    showAboutDialog(
      context: context,
      applicationName: AppInfo.name,
      applicationVersion: AppInfo.version,
      children: [
        Text(message),
      ],
    );
  }

  Future<void> _contactSupport(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final uri = Uri(
      scheme: 'mailto',
      path: AppInfo.supportEmail,
      queryParameters: {
        'subject': '${AppInfo.name} Support',
      },
    );

    if (await launchUrl(uri)) return;

    await Clipboard.setData(
      const ClipboardData(text: AppInfo.supportEmail),
    );

    if (!context.mounted) return;

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Support email copied to clipboard.'),
      ),
    );
  }

  Future<void> _clearAllData(BuildContext context) async {
    final confirmed = await ClearDataDialog.confirm(context);

    if (!confirmed || !context.mounted) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final profileController = context.read<ProfileController>();
    final tasksController = context.read<TasksController>();

    final cleared = await profileController.clearUserData();

    if (!context.mounted) return;

    if (!cleared) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            profileController.errorMessage ?? 'Could not clear data.',
          ),
        ),
      );
      return;
    }

    tasksController.clearLocalTasks();

    await navigator.pushNamedAndRemoveUntil(
      AppRoutes.welcome,
          (_) => false,
    );

    messenger.showSnackBar(
      const SnackBar(
        content: Text('All personal data has been cleared.'),
      ),
    );
  }

  String _themeLabel(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => 'System',
      AppThemeMode.light => 'Light',
      AppThemeMode.dark => 'Dark',
    };
  }

  String _languageLabel(AppLanguage language) {
    return switch (language) {
      AppLanguage.system => 'System default',
      AppLanguage.english => 'English',
      AppLanguage.arabic => 'العربية',
    };
  }
}
