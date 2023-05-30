import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_state.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

final prayerTimeViewModel =
    StateNotifierProvider.autoDispose<PrayerTimeViewModel, PrayerTimeStateNew>(
        (ref) {
  return PrayerTimeViewModel(
    prayerTimeServices: ref.watch(prayerTimeService),
    geocodingService: ref.watch(geocodingService),
    sharedPrefService: ref.watch(sharedPrefService),
    PrayerTimeStateNew(
      countDown: Duration.zero,
      nextPrayer: null,
      prayerTime: const AsyncValue.data(null),
      selectedCity: CityModel(id: '0101'),
      currentPrayer: null,
      listCity: const AsyncValue.data([]),
      lastKnownCity: const AsyncValue.data(null),
      autoDetectLocation: const AsyncValue.data(true),
    ),
  )..init();
});

class PrayerTimeViewModel extends StateNotifier<PrayerTimeStateNew> {
  PrayerTimeViewModel(
    super.state, {
    required PrayerTimeServices prayerTimeServices,
    required GeocodingService geocodingService,
    required SharedPrefService sharedPrefService,
  })  : _prayerTimeService = prayerTimeServices,
        _geocodingService = geocodingService,
        _sharedPrefService = sharedPrefService {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _setCurrentSecond(),
    );
  }
  Timer? timer;
  final PrayerTimeServices _prayerTimeService;
  final GeocodingService _geocodingService;
  final SharedPrefService _sharedPrefService;

  void _setCurrentSecond() {
    final nextPrayer = TimeOfDay.now().nextPrayer(
      state.prayerTime.value?.jadwal?.toListPrayerTimeDetail(),
    );
    if (nextPrayer == null) return;
    final currentPrayer = TimeOfDay.now().currentPrayer(
        state.prayerTime.value?.jadwal?.toListPrayerTimeDetail());

    final nextPrayerTime = nextPrayer.time;
    final now = DateTime.now();
    final nextPrayerDateTime = now.copyWith(
      hour: nextPrayerTime?.hour,
      minute: nextPrayerTime?.minute,
      second: 0,
    );

    final different = nextPrayerDateTime.difference(now);
    state = state.copyWith(
      countDown: different,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
    );
  }

  init() async {
    await getListCity();
    await Future.value([
      await getLastKnownCity(),
      await getAutoDetectLocationState(),
    ]);
    await getAllPrayerTime();
  }

  Future<void> getAllPrayerTime() async {
    try {
      state = state.copyWith(
        prayerTime: const AsyncValue.loading(),
      );

      final result = await _prayerTimeService.getPrayerTime(
        (state.autoDetectLocation.value!
                ? state.lastKnownCity.value?.id
                : state.selectedCity.id) ??
            '',
      );
      state = state.copyWith(
        prayerTime: AsyncValue.data(
          result,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        prayerTime: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> getListCity() async {
    try {
      state = state.copyWith(
        listCity: const AsyncValue.loading(),
      );
      final result = await _prayerTimeService.getListCity();
      state = state.copyWith(
        listCity: AsyncData(result),
      );
    } catch (e) {
      state = state.copyWith(listCity: AsyncError(e, StackTrace.current));
    }
  }

  Future<void> getLastKnownCity() async {
    try {
      state = state.copyWith(
        lastKnownCity: const AsyncLoading(),
      );
      final result = await _geocodingService.getCity();
      final lastKnownCity = state.listCity.value?.getFilterResult(result);
      if (lastKnownCity?.isEmpty ?? true) {
        state = state.copyWith(
          lastKnownCity: const AsyncData(null),
        );
      } else {
        state = state.copyWith(
          lastKnownCity: AsyncData(lastKnownCity!.first),
        );
      }
    } catch (e) {
      state = state.copyWith(
        lastKnownCity: AsyncError(e, StackTrace.current),
      );
    }
  }

  void setSelectedCity(CityModel cityModel) {
    state = state.copyWith(
      selectedCity: cityModel,
    );
    getAllPrayerTime();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future<void> getAutoDetectLocationState() async {
    try {
      state = state.copyWith(
        autoDetectLocation: const AsyncValue.loading(),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      bool? res = _sharedPrefService.getCache(SharePrefKey.autoDetectLocation);
      if (res == null) {
        res = true;
        await _sharedPrefService.setPref(SharePrefKey.autoDetectLocation, res);
      }
      state = state.copyWith(
        autoDetectLocation: AsyncData(res),
      );
    } catch (e) {
      state = state.copyWith(
        autoDetectLocation: AsyncError(e, StackTrace.current),
      );
    }
  }

  void setAutoDetectLocation(bool val) async {
    state = state.copyWith(
      autoDetectLocation: const AsyncValue.loading(),
    );
    if (val == true) {
      final result = await Permission.location.request();
      if (result.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
    }
    await _sharedPrefService.setPref(SharePrefKey.autoDetectLocation, val);
    getAutoDetectLocationState();
  }
}
