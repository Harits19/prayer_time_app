import 'package:prayer_time_app/constans/k_type.dart';
import 'package:prayer_time_app/services/home_widget_service.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

class CacheInterface {
  static Future<void> saveCache(Json? json, String selectedCityId) async {
    await SharedPrefService.saveCache(
      SharePrefKey.prayerTime,
      json,
    );
    await SharedPrefService.saveCache(SharePrefKey.lastCityId, selectedCityId);
    HomeWidgetService.updatePrayerWidget(json);
  }
}
