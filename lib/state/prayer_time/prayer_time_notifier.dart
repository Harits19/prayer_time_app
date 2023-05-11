import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/extensions/datetime_extension.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/home_widget_service.dart';
import 'package:prayer_time_app/services/notification_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:prayer_time_app/state/auto_detect_location/auto_detect_location_state.dart';
import 'package:prayer_time_app/state/current_city/current_city_state.dart';
import 'package:prayer_time_app/state/list_city/list_city_state.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_state.dart';
import 'package:timezone/timezone.dart';

class PrayerTimeNotifier extends StateNotifier<PrayerTimeState> {
  PrayerTimeNotifier(this.ref) : super(PrayerTimeState());

  final Ref ref;

  void init() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final resultFromCache =
          SharedPrefService.getCache(SharePrefKey.prayerTime);

      if (resultFromCache != null) {
        final cacheModel = PrayerTimeModel.fromJson(resultFromCache);
        state = state.copyWith(
          error: null,
          isLoading: false,
          prayerTime: cacheModel,
        );
      }

      if (ref.watch(autoDetectLocationState)) {
        final currentCityWatch = await ref.watch(currentCityState.future);
        final listCityWatch = await ref.watch(listCityState.future);
        final filteredList = listCityWatch.getFilterResult(currentCityWatch);
        final currentCityId = filteredList.first.id;

        state = state.copyWith(
          selectedCityId: currentCityId,
        );
      }

      await getPrayerTime();

      state = state.copyWith(
        isLoading: false,
      );

      saveCache();
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoading: false,
        prayerTime: state.prayerTime,
      );
    }
  }

  void updateId(String? id) async {
    state = state.copyWith(
      selectedCityId: id,
      isLoading: true,
    );
    await getPrayerTime();

    state = state.copyWith(
      isLoading: false,
    );
    saveCache();
  }

  void saveCache() async{
    final json = state.prayerTime?.toJson();
    await SharedPrefService.saveCache(
      SharePrefKey.prayerTime,
      json,
    );
    HomeWidgetService.updatePrayerWidget(json);
  }

  Future<void> getPrayerTime() async {
    final result = await PrayerTimeServices.getPrayerTime(
      state.selectedCityId,
    );
    state = state.copyWith(
      prayerTime: result,
    );
    final prayerTimes = (result?.jadwal ?? Jadwal()).toMappedTimeOfDay();
    await NotificationService.cancelAll();
    for (final prayer in prayerTimes.entries) {
      final prayerValue = prayer.value;
      if (prayerValue == null) throw 'Empty prayer time';
      NotificationService.scheduleNotification(
        TZDateTime.from(
          DateTime.now().applied(prayerValue),
          local,
        ),
        prayer.key,
        result?.lokasi.toCapitalize() ?? '-',
      );
    }
  }
}
