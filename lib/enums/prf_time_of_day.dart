enum PRFTimeOfDay {
  morning,
  evening
  ;

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

  int get hour {
    switch (this) {
      case PRFTimeOfDay.morning:
        return 8;
      case PRFTimeOfDay.evening:
        return 18;
    }
  }
}
