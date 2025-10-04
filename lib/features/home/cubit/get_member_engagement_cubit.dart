import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_member_engagement.dart';
import 'package:app/services/api/member_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_member_engagement_state.dart';
part 'get_member_engagement_cubit.freezed.dart';

class GetMemberEngagementCubit extends Cubit<GetMemberEngagementState> {
  GetMemberEngagementCubit({
    required MemberService memberService,
    required HiveService hiveService,
  }) : super(const GetMemberEngagementState.initial()) {
    _memberService = memberService;
    _hiveService = hiveService;
  }

  late MemberService _memberService;
  late HiveService _hiveService;

  Future<void> getMemberEngagement({
    required int year,
  }) async {
    emit(const GetMemberEngagementState.loading());

    try {
      final memberUlid = _hiveService.retrieveMember()!.ulid;
      final engagement = await _memberService.fetchMemberEngagement(
        memberUlid,
        year,
      );
      if (engagement.missionStats.totalMissions == 0) {
        emit(const GetMemberEngagementState.empty());
      } else {
        emit(GetMemberEngagementState.loaded(memberEngagement: engagement));
      }
    } on Failure catch (f) {
      emit(GetMemberEngagementState.error(f.message));
    } catch (e) {
      emit(GetMemberEngagementState.error(e.toString()));
    }
  }
}
