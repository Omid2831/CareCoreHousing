import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';

  static Future<void> save({
    required String name,
    required String email,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim());
  }

  static Future<Map<String, String?>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return <String, String?>{
      'name': prefs.getString(_nameKey),
      'email': prefs.getString(_emailKey),
    };
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
  }
}
