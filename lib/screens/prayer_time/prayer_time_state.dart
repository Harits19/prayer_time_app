import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/prayer_time_detail_model.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';

class PrayerTimeStateNew {
  final Duration countDown;
  final PrayerTimeDetailModel? nextPrayer;
  final PrayerTimeDetailModel? currentPrayer;
  final AsyncValue<PrayerTimeModel?> prayerTime;
  final String selectedCityId;

  PrayerTimeStateNew({
    required this.countDown,
    required this.nextPrayer,
    required this.prayerTime,
    required this.selectedCityId,
    required this.currentPrayer,
  });

  PrayerTimeStateNew copyWith({
    Duration? countDown,
    PrayerTimeDetailModel? nextPrayer,
    AsyncValue<PrayerTimeModel?>? prayerTime,
    String? selectedCityId,
    PrayerTimeDetailModel? currentPrayer,
  }) {
    return PrayerTimeStateNew(
      countDown: countDown ?? this.countDown,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      prayerTime: prayerTime ?? this.prayerTime,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      currentPrayer: currentPrayer ?? this.currentPrayer,
    );
  }
}
