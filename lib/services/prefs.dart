import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // ignore: non_constant_identifier_names
  static Future<bool> saveUserId(String user_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("user_id", user_id);
  }

  static Future<String?> loadUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString("user_id");
    return token;
  }

  // ignore: non_constant_identifier_names
  static Future<bool> removeUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove("user_id");
  }
}
