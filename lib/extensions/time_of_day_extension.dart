import 'package:flutter/material.dart';
import 'package:prayer_time_app/extensions/int_extension.dart';
import 'package:prayer_time_app/models/prayer_time_detail_model.dart';

extension TimeOfDayExtension on TimeOfDay {
  int toDouble() {
    return hour * 60 + minute;
  }
}

extension TimeOfDayNullExtension on TimeOfDay? {
  bool isBigger(TimeOfDay other) {
    final firstTime = toDouble();
    final secondTime = other.toDouble();
    if (firstTime == null) return false;
    return firstTime > secondTime;
  }

  bool isSmaller(TimeOfDay other) {
    return !isBigger(other);
  }

  int? toDouble() {
    if (this == null) return 0;
    return this!.toDouble();
  }

  PrayerTimeDetailModel? nextPrayer(
      List<PrayerTimeDetailModel>? mappedPrayer) {
    if (mappedPrayer == null) return null;
    PrayerTimeDetailModel? tempNextPrayer;
    for (final prayer in mappedPrayer) {
      final timePrayer = prayer.time;
      if (timePrayer == null) continue;
      final isSmaller = !TimeOfDay.now().isBigger(timePrayer);
      if (isSmaller) {
        tempNextPrayer = prayer;
        break;
      }
    }
    return tempNextPrayer;
  }

  PrayerTimeDetailModel? currentPrayer(
       List<PrayerTimeDetailModel>? mappedPrayer) {
    if (mappedPrayer == null) return null;
    PrayerTimeDetailModel? tempNextPrayer;
    for (final prayer in mappedPrayer) {
      final timePrayer = prayer.time;
      if (timePrayer == null) continue;
      final isBigger = TimeOfDay.now().isBigger(timePrayer);
      if (isBigger) {
        tempNextPrayer = prayer;
      }
    }
    return tempNextPrayer;
  }

  TimeOfDay? different(TimeOfDay? other) {
    if (this == null || other == null) return null;
    final firsTime = toDouble();
    final secondTime = other.toDouble();
    if (firsTime == null) return null;
    final timeDiff = (secondTime - firsTime).abs();
    final hourDif = timeDiff ~/ TimeOfDay.minutesPerHour;
    final minuteDif = timeDiff - (hourDif * TimeOfDay.minutesPerHour);
    return TimeOfDay(hour: hourDif, minute: minuteDif);
  }

  String to24Format() {
    final hourLabel = this?.hour.addLeadingZeroIfNeeded();
    final minuteLabel = this?.minute.addLeadingZeroIfNeeded();

    return '$hourLabel:$minuteLabel';
  }
}
