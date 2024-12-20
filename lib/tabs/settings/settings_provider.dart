import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  static ThemeMode themeMode = ThemeMode.light;
  static String languageCode = 'en';

  bool get isDark => themeMode == ThemeMode.dark;


  void changeTheme(ThemeMode selectedTheme){
    themeMode = selectedTheme;
    notifyListeners();
  }

  void changeLanguage(String selectedLanguage){
    if(selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;
    notifyListeners();
  }
}