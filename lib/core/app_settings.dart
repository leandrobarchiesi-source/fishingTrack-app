import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static String language = 'it';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language') ?? 'it';
  }

  static Future<void> saveLanguage(String value) async {
    language = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }
}