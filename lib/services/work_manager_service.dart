import 'dart:developer';

import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/interfaces/prayer_time_interface.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:workmanager/workmanager.dart';

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Future<void> refreshPrayerTimeInBackground() async {
    log("refreshPrayerTimeInBackground");
    try {
      final prefService = SharedPrefService();
      await prefService.initService();

      final autoDetectLocation =
          prefService.getCache(SharePrefKey.autoDetectLocation) ?? true;

      var lastKnownCityId = prefService.getCache(SharePrefKey.lastCityId);
      if (lastKnownCityId is! String || lastKnownCityId.isEmpty) {
        return;
      }

      log('auto detect location $autoDetectLocation');

      if (autoDetectLocation == true) {
        final currentCity = await GeocodingService().getCity();
        final listCity = await PrayerTimeServices().getListCity();
        final filteredList = listCity.getFilterResult(currentCity);
        lastKnownCityId = filteredList.first.id;
      }
      log(lastKnownCityId);
      log("after check lastKnownCityId");
      final result = await PrayerTimeServices().getPrayerTime(lastKnownCityId);
      log("resultRefreshBackground ${result?.toJson()}");
      await PrayerTimeInterface().saveCache(result, lastKnownCityId);
    } catch (e) {
      log("error from refreshPrayerTimeInBackground $e");
    }
  }

  Workmanager().executeTask((task, inputData) async {
    log(task);
    log(inputData.toString());
    switch (task) {
      case simplePeriodicTask:
        await refreshPrayerTimeInBackground();
        break;
    }
    return Future.value(true);
  });
}
