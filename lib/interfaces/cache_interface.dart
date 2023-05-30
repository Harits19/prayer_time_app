import 'dart:developer';

import 'package:prayer_time_app/extensions/datetime_extension.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/home_widget_service.dart';
import 'package:prayer_time_app/services/notification_service.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:timezone/timezone.dart';

@pragma('vm:entry-point')
class CacheInterface {
  static Future<void> saveCache(
      PrayerTimeModel? prayerTime, String selectedCityId) async {
    // save to pref
    final prayerTimeJson = prayerTime?.toJson();
    final prefService = SharedPrefService();
    await prefService.initService();

    await prefService.setPref(
      SharePrefKey.prayerTime,
      prayerTimeJson,
    );
    log("after save to pref");
    await prefService.setPref(SharePrefKey.lastCityId, selectedCityId);

    // update home widget
    await HomeWidgetService.updatePrayerWidget(prayerTimeJson);
    log("after update home widget");

    // update notification
    final schedule = (prayerTime?.jadwal ?? Jadwal()).toMappedTimeOfDay();
    await NotificationService.init();
    await NotificationService.cancelAll();
    for (final prayer in schedule.entries) {
      final prayerValue = prayer.value;
      if (prayerValue == null) throw 'Empty prayer time';
      NotificationService.scheduleNotification(
        TZDateTime.from(
          DateTime.now().applied(prayerValue),
          local,
        ),
        prayer.key,
        prayerTime?.lokasi.toCapitalize() ?? '-',
      );
    }
    log("after update notification");
  }
}
