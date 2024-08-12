enum PRFNotificationType {
  prayerPrompt;

  static PRFNotificationType fromType(String type) {
    switch (type) {
      case 'prayer_prompt':
        return PRFNotificationType.prayerPrompt;
      default:
        return PRFNotificationType.prayerPrompt;
    }
  }
}
