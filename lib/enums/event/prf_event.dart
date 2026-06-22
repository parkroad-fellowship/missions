import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFEvent {
  @JsonValue(1)
  courseMemberUpdated('Course Member Updated'),
  @JsonValue(2)
  memberModuleUpdated('Member Module Updated'),
  @JsonValue(3)
  lessonMemberUpdated('Lesson Member Updated'),
  @JsonValue(4)
  studentEnquiryReplyCreated('Student Enquiry Reply Created');

  const PRFEvent(this.name);

  final String name;

  static PRFEvent fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFEvent.courseMemberUpdated;
      case 2:
        return PRFEvent.memberModuleUpdated;
      case 3:
        return PRFEvent.lessonMemberUpdated;
      case 4:
        return PRFEvent.studentEnquiryReplyCreated;
      default:
        return PRFEvent.courseMemberUpdated;
    }
  }
}

enum PRFPresenceEvent {
  @JsonValue(5)
  announcementGroupCreated('Announcement Group Created');

  const PRFPresenceEvent(this.name);

  final String name;

  static PRFPresenceEvent fromIndex(int index) {
    switch (index) {
      case 5:
        return PRFPresenceEvent.announcementGroupCreated;
      default:
        return PRFPresenceEvent.announcementGroupCreated;
    }
  }
}
