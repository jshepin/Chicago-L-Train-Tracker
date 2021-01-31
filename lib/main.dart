import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ThemeManager implements IThemeModeManager {
  static const _key = 'themeMode';
  @override
  Future<String> loadThemeMode() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_key);
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(_key, value);
  }
}

abstract class ConfigReader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getServerURL() {
    return _config['serverURL'] as String;
  }

  static String getAPIKEY() {
    return _config['APIKEY'] as String;
  }
}

Future<void> main() async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize();

  runApp(EasyLocalization(
      supportedLocales: [Locale('en')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('es'),
      child: Main()));
}
