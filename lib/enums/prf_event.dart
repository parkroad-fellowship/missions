enum PRFEvent {
  coolBeans,
}

extension PRFEventExtension on PRFEvent {
  String get name {
    switch (this) {
      case PRFEvent.coolBeans:
        return 'Cool Beans';
    }
  }

  static PRFEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFEvent.coolBeans;
      default:
        return PRFEvent.coolBeans;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFEvent.coolBeans:
        return 1;
    }
  }
}
