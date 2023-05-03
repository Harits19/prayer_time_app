import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

extension StringExtension on String? {
  String? toCapitalize() {
    final splittedString = this?.toLowerCase().split(' ');
    final convertedString = splittedString
        ?.map((e) => e[0].toUpperCase() + e.substring(1, e.length));
    return convertedString?.join(' ');
  }

  String? formatDateGeorgian() {
    final tempDate = toDate();
    if (tempDate == null) return null;
    return DateFormat("EEEE, dd MMM yyyy").format(tempDate);
  }

  DateTime? toDate() {
    if (this == null) return null;
    return DateFormat("yyyy-MM-dd").parse(this!);
  }

  String? formatDateHijri() {
    if (toDate() == null) return null;
    return HijriCalendar.fromDate(toDate()!).toFormat("dd MMMM yyyy");
  }

  TimeOfDay? toTimeOfDay() {
    final splitedString = this?.split(":") ?? [];
    if (splitedString.isEmpty || splitedString.length != 2) return null;
    final hour = int.tryParse(splitedString[0]);
    final minute = int.tryParse(splitedString[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool get isNullEmpty => this?.isEmpty ?? false;
  
}
