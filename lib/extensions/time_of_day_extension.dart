import 'package:flutter/material.dart';
import 'package:prayer_time_app/extensions/int_extension.dart';

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

  int? toDouble() {
    if (this == null) return 0;
    return this!.toDouble();
  }

  MapEntry<String, TimeOfDay?>? nextPrayer(
      Map<String, TimeOfDay?>? mappedPrayer) {
    if (mappedPrayer == null) return null;
    MapEntry<String, TimeOfDay?>? tempNextPrayer;
    for (final prayer in mappedPrayer.entries) {
      final timePrayer = prayer.value;
      if (timePrayer == null) continue;
      final isSmaller = !TimeOfDay.now().isBigger(timePrayer);
      if (isSmaller) {
        tempNextPrayer = prayer;
        break;
      }
    }
    return tempNextPrayer;
  }

  MapEntry<String, TimeOfDay?>? currentPrayer(
      Map<String, TimeOfDay?>? mappedPrayer) {
    if (mappedPrayer == null) return null;
    MapEntry<String, TimeOfDay?>? tempNextPrayer;
    for (final prayer in mappedPrayer.entries) {
      final timePrayer = prayer.value;
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
