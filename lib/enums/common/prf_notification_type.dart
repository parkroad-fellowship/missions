enum PRFNotificationType {
  defaultPrompt,
  prayerPrompt,
  givingPrompt,
  newMission,
  cancelledMission,
  postponedMission,
  missionThankYou,
  missionWhatsappGroupCreated,
  missionSubscription,
  newEvent
  // studentEnquiry,
  // studentEnquiryReply
  ;

  static PRFNotificationType fromType(String type) {
    switch (type) {
      case 'prayer_prompt':
        return PRFNotificationType.prayerPrompt;
      case 'giving_prompt':
        return PRFNotificationType.givingPrompt;
      case 'new_mission':
        return PRFNotificationType.newMission;
      case 'cancelled_mission':
        return PRFNotificationType.cancelledMission;
      case 'postponed_mission':
        return PRFNotificationType.postponedMission;
      case 'mission_thank_you':
        return PRFNotificationType.missionThankYou;
      case 'mission_whatsapp_group_created':
        return PRFNotificationType.missionWhatsappGroupCreated;
      case 'mission_subscription':
        return PRFNotificationType.missionSubscription;
      case 'new_event':
        return PRFNotificationType.newEvent;
      // case 'student_enquiry':
      //   return PRFNotificationType.studentEnquiry;
      // case 'student_enquiry_reply':
      //   return PRFNotificationType.studentEnquiryReply;
      default:
        return PRFNotificationType.defaultPrompt;
    }
  }
}
