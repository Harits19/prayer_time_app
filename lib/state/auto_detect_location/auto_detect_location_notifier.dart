import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

class AutoDetectLocationNotifier extends StateNotifier<bool> {
  AutoDetectLocationNotifier() : super(false);

  void init() {
    state = SharedPrefService.getCache(SharePrefKey.autoDetectLocation);
  }

  void setValue(bool val) {
    state = val;
    SharedPrefService.saveCache(SharePrefKey.autoDetectLocation, val);
  }
}
