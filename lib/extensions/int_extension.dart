extension IntExtension on int? {
  String addLeadingZeroIfNeeded() {
    if ((this ?? 0) < 10) {
      return '0$this';
    }
    return toString();
  }
}
