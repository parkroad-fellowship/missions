enum PrfMembershipType {
  friend('Friend'),
  yearlyMember('Yearly Member'),
  lifetimeMember('Lifetime Member');

  const PrfMembershipType(this.name);
  final String name;

  static PrfMembershipType fromIndex(int index) {
    switch (index) {
      case 1:
        return PrfMembershipType.friend;
      case 2:
        return PrfMembershipType.yearlyMember;
      case 3:
        return PrfMembershipType.lifetimeMember;
      default:
        return PrfMembershipType.friend;
    }
  }
}
