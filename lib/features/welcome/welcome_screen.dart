import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/features/navigation/main_screen.dart';
import 'package:second_project/core/widgets/custom_button.dart';
import 'package:second_project/core/widgets/textFormField.dart';
import 'package:second_project/core/services/preferences_manager.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  // here I will Create EidtTextController :
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // First Column
          child: SingleChildScrollView(
            child: Form(
              key: nameKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  // First Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/Vector.svg",
                        width: 42,
                        height: 42,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Tasky",
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 108),
                  // Second Column
                  Column(
                    children: [
                      // Second Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome To Tasky",
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                          SvgPicture.asset(
                            "assets/icons/waving_hand.svg",
                            height: 28,
                            width: 28,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "your productivity journey starts here",
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 28),
                      SvgPicture.asset(
                        "assets/images/pana.svg",
                        height: 204,
                        width: 215,
                      ),
                      SizedBox(height: 28),
                      // treed column
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CutomTextFormField(
                                  titleText: "Full Name",
                                  hintText: "e.g. Sarah Khalid",
                                  myController: nameController,
                                  validatorText: "Please enter your name",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            onPressed: () async {
                              if (nameKey.currentState?.validate() ?? false) {
                                // here I will Use SharedPreferences :
                                await PreferencesManager().setString(
                                  StorageKey.username,
                                  nameController.value.text,
                                );
                                Navigator.pushReplacement(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return MainScreen();
                                    },
                                  ),
                                );
                                nameController.clear();
                              }
                            },
                            buttonText: "Let's Get Started",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
