import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharePrefKey {
  prayerTime,
  autoDetectLocation,
  lastCityId,
}

final sharedPrefService = Provider<SharedPrefService>((ref) {
  return SharedPrefService();
});

class SharedPrefService {
   SharedPreferences? prefs;

  SharedPrefService();

  Future<void> initService() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setPref(SharePrefKey sharePrefKey, Object? json) async {
    if (json == null) return;
    final jsonString = jsonEncode(json);
    await prefs?.setString(sharePrefKey.name, jsonString);
  }

  dynamic getCache(SharePrefKey sharePrefKey) {
    final jsonString = prefs?.getString(sharePrefKey.name);
    if (jsonString == null) return;
    return jsonDecode(jsonString);
  }
}
