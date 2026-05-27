enum PrfRole {
  superAdmin('super admin'),
  chairperson('chairperson'),
  viceChairperson('vice chairperson'),
  organisingSecretary('organising secretary'),
  missionCoordinator('mission coordinator'),
  viceMissionCoordinator('vice mission coordinator'),
  followUp('follow up'),
  treasurer('treasurer'),
  member('member'),
  student('student'),
  missionsCommitteeMember('missions committee member')
  ;

  const PrfRole(this.label);
  final String label;

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
