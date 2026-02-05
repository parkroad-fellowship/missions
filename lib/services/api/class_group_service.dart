import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/services/api/_base_api_service.dart';

class ClassGroupService extends BaseAPIService<PRFClassGroup> {
  @override
  String get endpoint => '/class-groups';

  @override
  PRFClassGroup createFromJson(Map<String, dynamic> json) {
    return PRFClassGroup.fromJson(json);
  }

  @override
  List<PRFClassGroup> createListFromResponse(Map<String, dynamic> response) {
    return PRFClassGroupResponse.fromJson(response).data;
  }
}
