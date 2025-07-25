import 'package:app/enums/prf_completion_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_lesson_member_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'finish_lesson_state.dart';
part 'finish_lesson_cubit.freezed.dart';

class FinishLessonCubit extends Cubit<FinishLessonState> {
  FinishLessonCubit({
    required LessonMemberService lessonMemberService,
    required HiveService hiveService,
    required IsarService isarService,
  }) : super(const FinishLessonState.initial()) {
    _lessonMemberService = lessonMemberService;
    _hiveService = hiveService;
    _isarService = isarService;
  }

  late LessonMemberService _lessonMemberService;
  late HiveService _hiveService;
  late IsarService _isarService;

  Future<void> finishLesson({
    required String lessonModuleUlid,
    required String courseModuleUlid,
  }) async {
    emit(const FinishLessonState.loading());

    try {
      final member = _hiveService.retrieveMember()!;

      final lessonModule = await _isarService.lessonModules.get(
        lessonModuleUlid,
      );
      final courseModule = await _isarService.courseModules.get(
        courseModuleUlid,
      );
      await _lessonMemberService.create(
        data: PRFLessonMemberDTO(
          lessonUlid: lessonModule!.lessonUlid,
          moduleUlid: lessonModule.moduleUlid,
          courseUlid: courseModule!.courseUlid,
          memberUlid: member.ulid,
          completionStatus: PRFCompletionStatus.complete,
        ).toJson(),
      );

      emit(const FinishLessonState.loaded());
    } on Failure catch (e) {
      emit(FinishLessonState.error(e.message));
    } catch (e) {
      emit(FinishLessonState.error(e.toString()));
    }
  }
}
