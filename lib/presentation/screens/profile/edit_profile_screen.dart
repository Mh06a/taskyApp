import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/presentation/controllers/edit_profile_controller.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

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
          final avatarExists = avatarPath != null &&
              File(avatarPath).existsSync();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit profile'),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: avatarExists
                              ? FileImage(File(avatarPath))
                              : null,
                          child: !avatarExists
                              ? const Icon(
                            Icons.person_outline_rounded,
                            size: 42,
                          )
                              : null,
                        ),
                        const SizedBox(height: 12),
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
                                color: Theme.of(context)
                                    .colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Display name',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 20),
                  Text(
                    'Motivational quote (optional)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: controller.quote,
                    maxLength: Limits.quote,
                    maxLines: 3,
                    enabled: !controller.isBusy,
                    onChanged: controller.updateQuote,
                    decoration: InputDecoration(
                      hintText: 'Small steps count.',
                      errorText: controller.quoteError,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (controller.errorMessage != null) ...[
                    Text(
                      controller.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
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