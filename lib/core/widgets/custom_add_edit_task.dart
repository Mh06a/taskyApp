import 'package:flutter/material.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/core/widgets/custom_add_buttton.dart';
import 'package:second_project/core/widgets/textFormField.dart';

class CustomAddEditTask extends StatelessWidget {
  //step1 ----> here Create Var for class :
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isHighPriority;
  final ValueChanged<bool> onChanged;
  final String buttonText;
  final Icon buttonIcon;
  final VoidCallback onPressed;

  const CustomAddEditTask({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.isHighPriority,
    required this.onChanged,
    required this.buttonText,
    required this.onPressed,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h8,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //step2.3 ----> here Create Task Name :
                    CutomTextFormField(
                      titleText: "Task Name",
                      hintText: "Finish UI design for login screen",
                      myController: nameController,
                      validatorText: "Please enter task name",
                    ),

                    SizedBox(height: AppSizes.h20),

                    //step2.4 ----> here Create task description :
                    CutomTextFormField(
                      titleText: "Task Description",
                      hintText:
                          "Finish onboarding UI and hand off to devs by Thursday.",
                      myController: descriptionController,
                      validatorText: "Please enter description task",
                      maxLines: 5,
                    ),

                    SizedBox(height: AppSizes.h24),

                    //step2.5 ----> here Create Row to Priority :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Switch(value: isHighPriority, onChanged: onChanged),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSizes.h40),
            //step5.6 ----> here Create Add Button :
            CustomAddButton(
              onPressed: onPressed,
              buttonText: buttonText,
              height: AppSizes.h40,
              width: AppSizes.w343,
              icon: buttonIcon,
            ),
          ],
        ),
      ),
    );
  }
}
