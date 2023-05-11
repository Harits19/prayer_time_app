import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

class AutoDetectLocationNotifier extends StateNotifier<bool> {
  AutoDetectLocationNotifier() : super(true);

  void init() {
    final res = SharedPrefService.getCache(SharePrefKey.autoDetectLocation);
    if (res == null) return;
    state = res;
  }

  void setValue(bool val) async {
    if (val == true) {
      final result = await Permission.location.request();
      if (result.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
    }

    state = val;
    SharedPrefService.saveCache(SharePrefKey.autoDetectLocation, val);
  }
}
