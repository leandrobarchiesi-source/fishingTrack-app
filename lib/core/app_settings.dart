import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static late SharedPreferences _prefs;

  static String language = 'it';

  static Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    language = _prefs.getString('language') ?? 'it';
  }

  static Future<void> saveLanguage(String value) async {
    language = value;
    await _prefs.setString('language', value);
  }

  // ===========================
  // Ultima sincronizzazione
  // ===========================

  static Future<void> saveLastSync(DateTime date) async {
    await _prefs.setInt(
      'last_sync',
      date.millisecondsSinceEpoch,
    );
  }

  static DateTime? get lastSync {
    final value = _prefs.getInt('last_sync');

    if (value == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(value);
  }
 
  static const String appVersion = "Beta 1.0 Build 1";

}

