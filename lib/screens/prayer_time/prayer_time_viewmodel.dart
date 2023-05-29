import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_state.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final prayerTimeViewModel =
    StateNotifierProvider.autoDispose<PrayerTimeViewModel, PrayerTimeStateNew>(
        (ref) {
  return PrayerTimeViewModel(
    prayerTimeServices: ref.watch(prayerTimeService),
    PrayerTimeStateNew(
      countDown: DateTime.now(),
      nextPrayer: null,
      prayerTime: const AsyncValue.data(null),
      selectedCityId: '0101',
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
    state = state.copyWith(
      countDown: DateTime.now(),
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
