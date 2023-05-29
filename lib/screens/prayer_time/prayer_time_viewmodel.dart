import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_state.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final prayerTimeViewModel =
    StateNotifierProvider.autoDispose<PrayerTimeViewModel, PrayerTimeStateNew>(
        (ref) {
  return PrayerTimeViewModel(
    prayerTimeServices: ref.watch(prayerTimeService),
    geocodingService: ref.watch(geocodingService),
    PrayerTimeStateNew(
      countDown: Duration.zero,
      nextPrayer: null,
      prayerTime: const AsyncValue.data(null),
      selectedCity: CityModel(id: '0101'),
      currentPrayer: null,
      listCity: const AsyncValue.data([]),
      lastKnownCity: const AsyncValue.data(null),
    ),
  )..init();
});

class PrayerTimeViewModel extends StateNotifier<PrayerTimeStateNew> {
  PrayerTimeViewModel(
    super.state, {
    required PrayerTimeServices prayerTimeServices,
    required GeocodingService geocodingService,
  })  : _prayerTimeService = prayerTimeServices,
        _geocodingService = geocodingService {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _setCurrentSecond(),
    );
  }
  Timer? timer;
  final PrayerTimeServices _prayerTimeService;
  final GeocodingService _geocodingService;

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
    await getLastKnownCity();
    await getAllPrayerTime();
  }

  Future<void> getAllPrayerTime() async {
    try {
      state = state.copyWith(
        prayerTime: const AsyncValue.loading(),
      );

      final result = await _prayerTimeService.getPrayerTime(
        (false ? state.lastKnownCity.value?.id : state.selectedCity.id) ?? '',
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
}
