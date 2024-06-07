import 'package:app/models/auth.dart';
import 'package:app/models/prf_church.dart';
import 'package:app/models/prf_marital_status.dart';
import 'package:app/models/prf_mission.dart';
import 'package:app/models/prf_profession.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_member.freezed.dart';
part 'prf_member.g.dart';

@freezed
class PRFMember with _$PRFMember {
  factory PRFMember(
    String ulid,
    int gender,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'phone_number') String phoneNumber,
    String email,
    String residence,
    String pastor, {
    @JsonKey(name: 'church_volunteer') required bool churchVolunteer,
    @JsonKey(name: 'accept_terms') required bool acceptTerms,
    @JsonKey(name: 'approved') required bool approved,
    @JsonKey(name: 'postal_address') required String postalAddress,
    @JsonKey(name: 'year_of_salvation') int? yearOfSalvation,
    @JsonKey(name: 'profession_institution') String? professionInstitution,
    @JsonKey(name: 'profession_location') String? professionLocation,
    @JsonKey(name: 'profession_contact') String? professionContact,
    PRFUser? user,
    @JsonKey(name: 'marital_status') PRFMaritalStatus? maritalStatus,
    PRFProfession? profession,
    PRFChurch? church,
    List<PRFMission>? missions,
  }) = _PRFMember;

  factory PRFMember.fromJson(Map<String, dynamic> json) =>
      _$PRFMemberFromJson(json);
}
