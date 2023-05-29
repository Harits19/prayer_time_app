import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/models/prayer_time_detail_model.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';

class PrayerTimeStateNew {
  final Duration countDown;
  final PrayerTimeDetailModel? nextPrayer;
  final PrayerTimeDetailModel? currentPrayer;
  final AsyncValue<PrayerTimeModel?> prayerTime;
  final CityModel selectedCity;
  final AsyncValue<List<CityModel>> listCity;
  final AsyncValue<CityModel?> lastKnownCity;

  PrayerTimeStateNew({
    required this.countDown,
    required this.nextPrayer,
    required this.prayerTime,
    required this.selectedCity,
    required this.currentPrayer,
    required this.listCity,
    required this.lastKnownCity,
  });

  PrayerTimeStateNew copyWith({
    Duration? countDown,
    PrayerTimeDetailModel? nextPrayer,
    AsyncValue<PrayerTimeModel?>? prayerTime,
    CityModel? selectedCity,
    PrayerTimeDetailModel? currentPrayer,
    AsyncValue<List<CityModel>>? listCity,
    AsyncValue<CityModel?>? lastKnownCity,
    AsyncValue<String>? initLoading,
  }) {
    return PrayerTimeStateNew(
      countDown: countDown ?? this.countDown,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      prayerTime: prayerTime ?? this.prayerTime,
      selectedCity: selectedCity ?? this.selectedCity,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      listCity: listCity ?? this.listCity,
      lastKnownCity: lastKnownCity ?? this.lastKnownCity,
    );
  }

  bool get isLoading =>  prayerTime.isLoading || listCity.isLoading || lastKnownCity.isLoading;
}
