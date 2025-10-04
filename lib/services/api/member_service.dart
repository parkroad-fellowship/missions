import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_member_engagement.dart';
import 'package:app/services/api/_base_api_service.dart';

class MemberService extends BaseAPIService<PRFMember> {
  @override
  String get endpoint => '/members';

  @override
  PRFMember createFromJson(Map<String, dynamic> json) {
    return PRFMember.fromJson(json);
  }

  @override
  List<PRFMember> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    throw UnimplementedError();
  }

  Future<PRFMemberEngagement> fetchMemberEngagement(
    String memberUlid,
    int year,
  ) async {
    return getChild(
      parentId: memberUlid,
      childPath: 'engagement',
      fromJson: PRFMemberEngagement.fromJson,
      queryParameters: {
        'include_badges': true,
        'include_comparative_stats': true,
        'year': year,
      },
    );
  }
}
