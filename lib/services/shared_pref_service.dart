import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum SharePrefKey {
  prayerTime,
}

class SharedPrefService {
  static SharedPreferences? prefs;

  static Future<void> initService() async {
    prefs = await SharedPreferences.getInstance();
  }

  static saveCache(SharePrefKey sharePrefKey, Map<String, dynamic> json) {
    final jsonString = jsonEncode(json);
    prefs?.setString(sharePrefKey.name, jsonString);
  }

  static dynamic getCache(SharePrefKey sharePrefKey) {
    final jsonString = prefs?.getString(sharePrefKey.name);
    if (jsonString == null) return;
    return jsonDecode(jsonString);
  }
}
