import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/models/local/course/prf_lesson_module.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/course/prf_lesson_member_dto.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/api/lesson_module_service.dart';
import 'package:app/services/local_storage/_index.dart';
import 'package:app/utils/crud/resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';

class LessonResourceCubit
    extends ResourceCubit<PRFLessonModule, PRFLocalLessonModule> {
  LessonResourceCubit({
    required LessonModuleService lessonModuleService,
    required HiveService hiveService,
    LessonMemberService? lessonMemberService,
    super.dbService,
  }) : _hiveService = hiveService,
       _lessonMemberService = lessonMemberService,
       super(service: lessonModuleService) {
    subscribeToIsarUpdates();
  }

  final HiveService _hiveService;
  final LessonMemberService? _lessonMemberService;

  @override
  List<String> get defaultIncludes => ['lesson', 'lessonMember', 'module'];

  /// Mark a lesson as finished by creating a LessonMember record.
  Future<void> finishLesson({
    required String lessonUlid,
    required String moduleUlid,
    required String courseUlid,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.update,
      ),
    );

    try {
      if (_lessonMemberService == null) {
        throw Exception('LessonMemberService not provided');
      }
      final dto = PRFLessonMemberDTO(
        lessonUlid: lessonUlid,
        moduleUlid: moduleUlid,
        courseUlid: courseUlid,
        memberUlid: _hiveService.retrieveMember()!.ulid,
        completionStatus: PRFCompletionStatus.complete,
      );
      await _lessonMemberService.create(data: dto.toJson());
      emit(
        ResourceState.mutated(
          items: currentItems,
          operation: ResourceOperation.update,
        ),
      );
      // Reload to transition back to listLoaded with updated lessonMember data.
      // Unlike base class mutations, finishLesson creates a different entity
      // (LessonMember), so Isar streams won't auto-trigger a refresh.
      await loadAll(filters: {'module_ulid': moduleUlid});
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }
}
