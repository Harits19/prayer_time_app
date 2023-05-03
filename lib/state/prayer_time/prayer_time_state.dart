import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_notifier.dart';

final prayerTimeState =
    StateNotifierProvider<PrayerTimeNotifier, PrayerTimeState>(
  (ref) {
    return PrayerTimeNotifier(ref)..init();
  },
);

class PrayerTimeState {
  final PrayerTimeModel? prayerTime;
  final bool isLoading;
  final Object? error;
  final String selectedCityId;

  PrayerTimeState(
      {this.prayerTime,
      this.isLoading = false,
      this.error,
      this.selectedCityId = '0101'});

  PrayerTimeState copyWith({
    PrayerTimeModel? prayerTime,
    bool? isLoading,
    Object? error,
    String? selectedCityId,
  }) {
    return PrayerTimeState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      prayerTime: prayerTime ?? this.prayerTime,
      selectedCityId: selectedCityId ?? this.selectedCityId,
    );
  }
}
