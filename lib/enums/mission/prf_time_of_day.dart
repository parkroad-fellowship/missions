enum PRFTimeOfDay {
  morning(1, 'Morning', 8),
  evening(2, 'Evening', 18);

  const PRFTimeOfDay(this.apiKey, this.name, this.hour);
  final int apiKey;
  final String name;
  final int hour;

  static PRFTimeOfDay fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFTimeOfDay.morning;
      case 2:
        return PRFTimeOfDay.evening;
      default:
        return PRFTimeOfDay.morning;
    }
  }
}
