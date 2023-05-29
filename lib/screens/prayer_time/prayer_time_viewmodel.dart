import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_state.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final prayerTimeViewModel =
    StateNotifierProvider.autoDispose<PrayerTimeViewModel, PrayerTimeStateNew>(
        (ref) {
  return PrayerTimeViewModel(
    prayerTimeServices: ref.watch(prayerTimeService),
    PrayerTimeStateNew(
      countDown: Duration.zero,
      nextPrayer: null,
      prayerTime: const AsyncValue.data(null),
      selectedCityId: '0101',
      currentPrayer: null,
    ),
  )..getAllPrayerTime();
});

class PrayerTimeViewModel extends StateNotifier<PrayerTimeStateNew> {
  PrayerTimeViewModel(super.state,
      {required PrayerTimeServices prayerTimeServices})
      : _prayerTimeService = prayerTimeServices {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _setCurrentSecond(),
    );
  }
  Timer? timer;
  final PrayerTimeServices _prayerTimeService;

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

  void getAllPrayerTime() async {
    try {
      state = state.copyWith(
        prayerTime: const AsyncValue.loading(),
      );
      final result = await _prayerTimeService.getPrayerTime(
        state.selectedCityId,
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

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
