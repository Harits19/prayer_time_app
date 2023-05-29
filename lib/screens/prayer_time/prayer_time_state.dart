import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/prayer_time_detail_model.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';

class PrayerTimeStateNew {
  final DateTime countDown;
  final PrayerTimeDetailModel? nextPrayer;
  final AsyncValue<PrayerTimeModel?> prayerTime;
  final String selectedCityId;

  PrayerTimeStateNew({
    required this.countDown,
    required this.nextPrayer,
    required this.prayerTime,
    required this.selectedCityId,
  });

  PrayerTimeStateNew copyWith({
    DateTime? countDown,
    PrayerTimeDetailModel? nextPrayer,
    AsyncValue<PrayerTimeModel?>? prayerTime,
    String? selectedCityId,
  }) {
    return PrayerTimeStateNew(
      countDown: countDown ?? this.countDown,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      prayerTime: prayerTime ?? this.prayerTime,
      selectedCityId: selectedCityId ?? this.selectedCityId,
    );
  }
}
