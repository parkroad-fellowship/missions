import 'dart:math';

import 'package:intl/intl.dart';

class Misc {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime.toLocal());
  }

  static String formatDate(DateTime dateTime) =>
      DateFormat.yMMMMd().format(dateTime.toLocal());

  static String formatTime(String time) =>
      DateFormat.jm().format(DateTime.parse('2012-02-27 $time'));

  static String getUserNameInitials(String userName) {
    var initials = 'U';
    if (userName.isNotEmpty) {
      final index = userName.indexOf(' ');
      initials = userName[0].toUpperCase();
      if (index != -1) {
        initials = initials + userName[index + 1].toUpperCase();
      }
    }
    return initials;
  }

  static double truncateToDecimalPlaces(double value, int fractionalDigits) =>
      (value * pow(10, fractionalDigits)).truncate() /
      pow(10, fractionalDigits);
}
