import 'package:flutter/material.dart';
import 'package:second_project/Widgets/custom_add_buttton.dart';
import 'package:second_project/Widgets/textFormField.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                    SizedBox(height: 20),

                    //step2.4 ----> here Create task description :
                    CutomTextFormField(
                      titleText: "Task Description",
                      hintText:
                          "Finish onboarding UI and hand off to devs by Thursday.",
                      myController: descriptionController,
                      validatorText: "Please enter description task",
                      maxLines: 5,
                    ),

                    SizedBox(height: 24),

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

            SizedBox(height: 40),
            //step5.6 ----> here Create Add Button :
            CustomAddButton(
              onPressed: onPressed,
              buttonText: buttonText,
              height: 40,
              width: 343,
              icon: buttonIcon,
            ),
          ],
        ),
      ),
    );
  }
}
