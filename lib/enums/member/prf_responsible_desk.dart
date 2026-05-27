import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFResponsibleDesk {
  @JsonValue(1)
  chairperson(1, 'Chairperson'),
  @JsonValue(2)
  viceChairperson(2, 'Vice Chairperson'),
  @JsonValue(3)
  organisingSecretary(3, 'Organising Secretary'),
  @JsonValue(4)
  missions(4, 'Missions Desk'),
  @JsonValue(5)
  prayer(5, 'Prayer Desk'),
  @JsonValue(6)
  followUp(6, 'Follow-up Desk'),
  @JsonValue(7)
  music(7, 'Music Desk'),
  @JsonValue(8)
  treasurer(8, 'Treasurer')
  ;

  const PRFResponsibleDesk(this.apiKey, this.name);

  final int apiKey;
  final String name;

  static PRFResponsibleDesk fromRole(
    String role,
  ) {
    switch (role) {
      case 'chairperson':
        return PRFResponsibleDesk.chairperson;
      case 'vice chairperson':
        return PRFResponsibleDesk.viceChairperson;
      case 'organising secretary':
        return PRFResponsibleDesk.organisingSecretary;
      case 'missions secretary':
        return PRFResponsibleDesk.missions;
      case 'prayer secretary':
        return PRFResponsibleDesk.prayer;
      case 'follow-up secretary':
        return PRFResponsibleDesk.followUp;
      case 'music secretary':
        return PRFResponsibleDesk.music;
      case 'treasurer':
        return PRFResponsibleDesk.treasurer;
      default:
        throw Exception('Unknown role: $role');
    }
  }

  static List<PRFResponsibleDesk> fromRoles(List<String> roles) {
    return roles
        .map((role) {
          try {
            return fromRole(role);
          } catch (e) {
            return null;
          }
        })
        .whereType<PRFResponsibleDesk>()
        .toList();
  }

  static List<int> apiKeys(List<PRFResponsibleDesk> desks) {
    return desks.map((desk) => desk.apiKey).toList();
  }
}
