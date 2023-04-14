import 'package:intl/intl.dart';

extension StringExtension on String? {
  String? toCapitalize() {
    final splittedString = this?.toLowerCase().split(' ');
    final convertedString = splittedString
        ?.map((e) => e[0].toUpperCase() + e.substring(1, e.length));
    return convertedString?.join(' ');
  }

  String? formatDate() {
    if (this == null) return null;
    final tempDate = DateFormat("yyyy-MM-dd").parse(this!);
    return DateFormat("E, dd MMM yyyy").format(tempDate);
  }
}
