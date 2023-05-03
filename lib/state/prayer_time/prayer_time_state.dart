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

  PrayerTimeState({this.prayerTime, this.isLoading = false, this.error});
}
