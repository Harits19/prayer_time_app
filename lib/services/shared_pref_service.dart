import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum SharePrefKey {
  prayerTime,
  autoDetectLocation
}

class SharedPrefService {
  static SharedPreferences? prefs;

  static Future<void> initService() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveCache(SharePrefKey sharePrefKey, Object? json) async{
    if (json == null) return;
    final jsonString = jsonEncode(json);
    await prefs?.setString(sharePrefKey.name, jsonString);
  }

  static dynamic getCache(SharePrefKey sharePrefKey) {
    final jsonString = prefs?.getString(sharePrefKey.name);
    if (jsonString == null) return;
    return jsonDecode(jsonString);
  }
}
