import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/presentation/controllers/edit_profile_controller.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileController(
        profileController: context.read<ProfileController>(),
        saveAvatar: context.read<SaveAvatarUseCase>(),
        deleteAvatar: context.read<DeleteAvatarUseCase>(),
      ),
      child: Consumer<EditProfileController>(
        builder: (context, controller, _) {
          final avatarPath = controller.avatarPath;
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit profile'),
            ),
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding,
                  vertical: AppSizes.screenVerticalPadding,
                ),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.avatarLarge / 2,
                          child: avatarPath == null
                              ? AppSvgIcon(assetPath: AppAssets.profileIcon
                            , size: AppSizes.icon32,)
                              : ClipOval(
                            child: Image.file(
                              File(avatarPath),
                              width: AppSizes.avatarLarge,
                              height: AppSizes.avatarLarge,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return SizedBox(
                                  width: AppSizes.avatarLarge,
                                  height: AppSizes.avatarLarge,
                                  child: AppSvgIcon(assetPath: AppAssets.profileIcon
                                    , size: AppSizes.icon32,)
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.s12),
                        TextButton(
                          onPressed: controller.isBusy
                              ? null
                              : controller.pickAvatar,
                          child: Text(
                            controller.isPickingAvatar
                                ? 'Selecting photo...'
                                : 'Change photo',
                          ),
                        ),
                        if (controller.hasAvatar)
                          TextButton(
                            onPressed: controller.isBusy
                                ? null
                                : controller.removeAvatar,
                            child: Text(
                              'Remove photo',
                              style: TextStyle(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.s24),
                  Text(
                    'Display name',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.s8),
                  TextFormField(
                    initialValue: controller.name,
                    maxLength: Limits.userName,
                    textCapitalization: TextCapitalization.words,
                    enabled: !controller.isBusy,
                    onChanged: controller.updateName,
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      counterText: '',
                      errorText: controller.nameError,
                    ),
                  ),
                  SizedBox(height: AppSizes.s20),
                  Text(
                    'Motivational quote (optional)',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.s8),
                  TextFormField(
                    initialValue: controller.quote,
                    maxLength: Limits.quote,
                    maxLines: 3,
                    enabled: !controller.isBusy,
                    onChanged: controller.updateQuote,
                    decoration: InputDecoration(
                      hintText: Limits.defaultQuote,
                      errorText: controller.quoteError,
                    ),
                  ),
                  SizedBox(height: AppSizes.s28),
                  if (controller.errorMessage != null) ...[
                    Text(
                      controller.errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    SizedBox(height: AppSizes.s12),
                  ],
                  AppButton(
                    text: 'Save profile',
                    isLoading: controller.isSaving,
                    onPressed: controller.isBusy
                        ? null
                        : () async {
                      if (await controller.save() &&
                          context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
