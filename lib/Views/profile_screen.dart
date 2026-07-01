import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_project/Views/user_details.dart';
import 'package:second_project/Views/welcome_screen.dart';
import 'package:second_project/services/preferences_manager.dart';
import 'package:second_project/themes/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //step1 ---- Create vars for class :
  String? username;
  String? motivationQuote;
  File? _selectedImage;

  //step3 ---- call initState() :
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //step4 ---- create a function to load username :
  void _loadUserData() async {
    setState(() {
      username = PreferencesManager().getString("username") ?? "Guset";
      motivationQuote =
          PreferencesManager().getString("motivation_quote") ?? "Nothing";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //step2.1 ----> here Create text tp  AppBar :
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "My Profile",
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontSize: 20),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 16),

          //step2.2 ----> here Create the body :
          Center(
            child: Column(
              children: [
                //step2.2.1 ----> here Create the image  :
                Stack(
                  alignment: AlignmentGeometry.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: _selectedImage == null
                          ? AssetImage("assets/images/me.jpg")
                          : FileImage(_selectedImage!),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showImageSourceDialog(context, (XFile file) {
                          setState(() {
                            _selectedImage = File(file.path);
                          });
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.surface,
                        ),

                        child: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                //step2.2.2 ----> here Create the user name  :
                Text(
                  "$username",
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  "$motivationQuote",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Profile Info",
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontSize: 20),
          ),
          SizedBox(height: 16),
          //step2.2.3 ----> here Create the profile details:  :
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return UserDetails();
                  },
                ),
              );
              if (result) {
                _loadUserData();
              }
            },
            leading: SvgPicture.asset(
              "assets/icons/user_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              "User Details",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: SvgPicture.asset(
              "assets/icons/arrow_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),

          Divider(color: Theme.of(context).colorScheme.outline),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset(
              "assets/icons/moon_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: ValueListenableBuilder(
              valueListenable: ThemeController.valueNotifier,
              builder: (context, value, child) {
                return Switch(
                  value: value == ThemeMode.dark,
                  onChanged: (bool value) async {
                    ThemeController.toggleTheme();
                  },
                );
              },
            ),
          ),

          Divider(color: Theme.of(context).colorScheme.outline),

          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              PreferencesManager().remove("username");
              PreferencesManager().remove("motivation_quote");
              PreferencesManager().remove("tasks");
              await Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return WelcomeScreen();
                  },
                ),
                (Route<dynamic> route) => false,
              );
            },
            leading: SvgPicture.asset(
              "assets/icons/logout_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              "Log Out",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: SvgPicture.asset(
              "assets/icons/arrow_icon.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //step5 ---- create a function to show dilog :
  void showImageSourceDialog(
    BuildContext context,
    Function(XFile) selectedFile,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Choose Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );

                if (image != null) {
                  selectedFile(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(children: [Icon(Icons.camera_alt), Text("Camera")]),
            ),
            // -----
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  selectedFile(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [Icon(Icons.photo_library), Text("Gallery")],
              ),
            ),
          ],
        );
      },
    );
  }
}
