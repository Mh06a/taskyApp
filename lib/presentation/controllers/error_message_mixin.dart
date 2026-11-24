import 'package:flutter/foundation.dart';

mixin ErrorMessageMixin on ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    if (_errorMessage == value) return;
    _errorMessage = value;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}
