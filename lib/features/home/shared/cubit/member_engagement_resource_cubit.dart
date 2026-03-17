import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/services/api/member_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';

/// Manages member engagement data. Uses a custom API call
/// (fetchMemberEngagement) instead of standard CRUD list because
/// engagement is a single computed resource, not a list endpoint.
class MemberEngagementResourceCubit
    extends Cubit<ResourceState<PRFMemberEngagement>> {
  MemberEngagementResourceCubit({
    required MemberService memberService,
  })  : _memberService = memberService,
        super(const ResourceState.initial());

  final MemberService _memberService;

  /// Load member engagement for a given member and year.
  Future<void> loadEngagement({
    required String memberUlid,
    required int year,
  }) async {
    emit(const ResourceState.listLoading());
    try {
      final engagement = await _memberService.fetchMemberEngagement(
        memberUlid,
        year,
      );
      emit(ResourceState.listLoaded(items: [engagement]));
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message));
    } catch (e) {
      emit(ResourceState.error(message: e.toString()));
    }
  }

  /// Reset to initial state.
  void reset() => emit(const ResourceState.initial());
}
