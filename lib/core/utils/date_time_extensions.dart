extension DateTimeExtensions on DateTime {
  DateTime toMidnight() {
    return DateTime(year, month, day);
  }
}
