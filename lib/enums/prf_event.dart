import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFEvent {
  @JsonValue(1)
  courseMemberUpdated,
  @JsonValue(2)
  memberModuleUpdated,
  @JsonValue(3)
  lessonMemberUpdated,
  @JsonValue(4)
  studentEnquiryReplyCreated
  ;

  String get name {
    switch (this) {
      case PRFEvent.courseMemberUpdated:
        return 'Course Member Updated';
      case PRFEvent.memberModuleUpdated:
        return 'Member Module Updated';
      case PRFEvent.lessonMemberUpdated:
        return 'Lesson Member Updated';
      case PRFEvent.studentEnquiryReplyCreated:
        return 'Student Enquiry Reply Created';
    }
  }

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
  announcementGroupCreated
  ;

  String get name {
    switch (this) {
      case PRFPresenceEvent.announcementGroupCreated:
        return 'Announcement Group Created';
    }
  }

  static PRFPresenceEvent fromIndex(int index) {
    switch (index) {
      case 5:
        return PRFPresenceEvent.announcementGroupCreated;
      default:
        return PRFPresenceEvent.announcementGroupCreated;
    }
  }
}
