import 'package:shared_preferences/shared_preferences.dart';

class CacheHandler {
  static Future<String> readCache(String key) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString(key);
  }

  static writeCache(String key, String value) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(key, value);
  }

  static deleteCache() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    storage.clear();
    return null;
  }
}
