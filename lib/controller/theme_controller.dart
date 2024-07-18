import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  bool isDarkMode = false;

  bool get nightmode {
    return isDarkMode;
  }

  void toggleThemeMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}