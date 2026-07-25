import 'package:flutter/material.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/core/widgets/custom_button.dart';
import 'package:second_project/core/widgets/textFormField.dart';
import 'package:second_project/core/services/preferences_manager.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  //step1 ---- Create vars for class :
  final TextEditingController nameController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  //step3 ---- call initState() :
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  //step4 ---- create a function to load user data :
  void loadUserData() async {
    nameController.text =
        PreferencesManager().getString(StorageKey.username) ?? "null";
    motivationController.text =
        PreferencesManager().getString(StorageKey.motivationQuote) ?? "null";
  }

  //step2 ---- Create The page :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              CutomTextFormField(
                titleText: "User Name",
                hintText: "Mansour Hussain",
                myController: nameController,
                validatorText: "Please enter your name",
              ),

              SizedBox(height: AppSizes.h20),

              CutomTextFormField(
                titleText: "Motivation Quote",
                hintText: "One task at a time. One step closer.",
                myController: motivationController,
                validatorText: "Please enter your name",
                maxLines: 5,
              ),
              Spacer(),
              CustomButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    await PreferencesManager().setString(
                      StorageKey.username,
                      nameController.value.text,
                    );
                    await PreferencesManager().setString(
                      StorageKey.motivationQuote,
                      motivationController.value.text,
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                },
                buttonText: 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
