import 'package:app/models/prf_contact_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_contact.freezed.dart';
part 'prf_contact.g.dart';

@freezed
class PRFContact with _$PRFContact {
  factory PRFContact(
    String ulid,
    String name,
    String phone,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    String? email,
    @JsonKey(name: 'contact_type') PRFContactType? contactType,
  }) = _PRFContact;

  factory PRFContact.fromJson(Map<String, dynamic> json) =>
      _$PRFContactFromJson(json);
}
