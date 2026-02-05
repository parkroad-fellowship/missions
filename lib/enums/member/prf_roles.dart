enum PrfRole {
  superAdmin,
  chairperson,
  viceChairperson,
  organisingSecretary,
  missionCoordinator,
  viceMissionCoordinator,
  followUp,
  treasurer,
  member,
  student,
  missionsCommitteeMember
  ;

  String get label {
    switch (this) {
      case PrfRole.superAdmin:
        return 'super admin';
      case PrfRole.chairperson:
        return 'chairperson';
      case PrfRole.viceChairperson:
        return 'vice chairperson';
      case PrfRole.organisingSecretary:
        return 'organising secretary';
      case PrfRole.missionCoordinator:
        return 'mission coordinator';
      case PrfRole.viceMissionCoordinator:
        return 'vice mission coordinator';
      case PrfRole.followUp:
        return 'follow up';
      case PrfRole.treasurer:
        return 'treasurer';
      case PrfRole.member:
        return 'member';
      case PrfRole.student:
        return 'student';
      case PrfRole.missionsCommitteeMember:
        return 'missions committee member';
    }
  }

  static PrfRole fromLabel(String label) {
    switch (label) {
      case 'super admin':
        return PrfRole.superAdmin;
      case 'chairperson':
        return PrfRole.chairperson;
      case 'vice chairperson':
        return PrfRole.viceChairperson;
      case 'organising secretary':
        return PrfRole.organisingSecretary;
      case 'mission coordinator':
        return PrfRole.missionCoordinator;
      case 'vice mission coordinator':
        return PrfRole.viceMissionCoordinator;
      case 'follow up':
        return PrfRole.followUp;
      case 'treasurer':
        return PrfRole.treasurer;
      case 'member':
        return PrfRole.member;
      case 'student':
        return PrfRole.student;
      case 'missions committee member':
        return PrfRole.missionsCommitteeMember;
      default:
        return PrfRole.member;
    }
  }
}
