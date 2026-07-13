import 'package:flutter/material.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/core/services/preferences_manager.dart';
import 'package:second_project/models/task.dart';

class HomeController extends ChangeNotifier {
  //step1 ---- Create vars for class :
  String? username;
  String? motivationQuote;
  List<TaskModel> tasks = [];

  //step3 ----  here I will Create init function :
  void init() {
    loadUserData();
  }

  //step4 ---- create a function to load load User Data :
  void loadUserData() async {
    username = PreferencesManager().getString(StorageKey.username) ?? "Guset";
    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote) ?? "Nothing";

    notifyListeners();
  }
}
