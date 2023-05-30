import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/datetime_extension.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/home_widget_service.dart';
import 'package:prayer_time_app/services/notification_service.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:timezone/timezone.dart';

final prayerTimeInterface = Provider<PrayerTimeInterface>((ref) {
  return PrayerTimeInterface();
});

@pragma('vm:entry-point')
class PrayerTimeInterface {
  Future<void> saveCache(
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
    final schedule = (prayerTime?.jadwal ?? Jadwal()).toListPrayerTimeDetail();
    await NotificationService.init();
    await NotificationService.cancelAll();
    for (final prayer in schedule) {
      final prayerValue = prayer.time;
      if (prayerValue == null) throw Exception('Empty prayer time');
      NotificationService.scheduleNotification(
        TZDateTime.from(
          DateTime.now().applied(prayerValue),
          local,
        ),
        prayer.name,
        prayerTime?.lokasi.toCapitalize() ?? '-',
      );
    }
    log("after update notification");
  }
}
