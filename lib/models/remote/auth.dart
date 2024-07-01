import 'package:app/models/remote/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Generated model files
part 'auth.g.dart'; // Needed for toJson, fromJson
part 'auth.freezed.dart';

@freezed
class SignInDTO with _$SignInDTO {
  factory SignInDTO({
    required String email,
    required String password,
  }) = _SignInDTO;

  factory SignInDTO.fromJson(Map<String, dynamic> json) =>
      _$SignInDTOFromJson(json);
}

@freezed
class PRFUser with _$PRFUser {
  factory PRFUser({
    required String ulid,
    required String name,
    required String email,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<PRFRole> roles,
    PRFMember? member,
    int? password,
  }) = _PRFUser;

  factory PRFUser.fromJson(Map<String, dynamic> json) =>
      _$PRFUserFromJson(json);
}

@freezed
class PRFRole with _$PRFRole {
  factory PRFRole({
    required String name,
    required List<PRFPermission> permissions,
  }) = _PRFRole;

  factory PRFRole.fromJson(Map<String, dynamic> json) =>
      _$PRFRoleFromJson(json);
}

@freezed
class PRFPermission with _$PRFPermission {
  factory PRFPermission({
    required String name,
  }) = _PRFPermission;

  factory PRFPermission.fromJson(Map<String, dynamic> json) =>
      _$PRFPermissionFromJson(json);
}
