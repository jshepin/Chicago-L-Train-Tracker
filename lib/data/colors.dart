import 'package:flutter/material.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

Color getPrimary(context) {
  return isDark(context) ? Color(0xff292929) : Colors.white;
}

Color getSecondary(context) {
  return isDark(context) ? Color(0xff1e1e1e) : Colors.white;
}

bool isDark(context) {
  var theme = MediaQuery.of(context).platformBrightness;
  var themeMode = ThemeModeHandler.of(context).themeMode;
  if (themeMode == ThemeMode.system) {
    return theme == Brightness.dark;
  } else if (themeMode == ThemeMode.dark) {
    return true;
  } else {
    return false;
  }
}
