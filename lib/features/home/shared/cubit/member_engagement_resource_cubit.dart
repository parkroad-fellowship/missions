import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/services/api/member_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';

/// Manages member engagement data. Uses a custom API call
/// (fetchMemberEngagement) instead of standard CRUD list because
/// engagement is a single computed resource, not a list endpoint.
class MemberEngagementResourceCubit
    extends Cubit<ResourceState<PRFMemberEngagement>> {
  MemberEngagementResourceCubit({
    required MemberService memberService,
    required HiveService hiveService,
  }) : _memberService = memberService,
       _hiveService = hiveService,
       super(const ResourceState.initial());

  late final MemberService _memberService;
  late final HiveService _hiveService;

  /// Load member engagement for a given member and year.
  Future<void> loadEngagement({
    required int year,
  }) async {
    final ulid = _hiveService.retrieveMember()?.ulid;
    if (ulid == null) {
      emit(const ResourceState.error(message: 'Member not found'));
      return;
    }

    emit(const ResourceState.listLoading());
    try {
      final engagement = await _memberService.fetchMemberEngagement(
        ulid,
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
