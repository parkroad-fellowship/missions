enum PRFNotificationType {
  defaultPrompt,
  prayerPrompt,
  givingPrompt;

  static PRFNotificationType fromType(String type) {
    switch (type) {
      case 'prayer_prompt':
        return PRFNotificationType.prayerPrompt;
      case 'giving_prompt':
        return PRFNotificationType.givingPrompt;
      default:
        return PRFNotificationType.defaultPrompt;
    }
  }
}
