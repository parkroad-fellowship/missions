import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/api/lesson_module_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';

class LessonResourceCubit extends ResourceCubit<PRFLessonModule> {
  LessonResourceCubit({
    required LessonModuleService lessonModuleService,
    LessonMemberService? lessonMemberService,
    super.dbService,
  }) : _lessonMemberService = lessonMemberService,
       super(service: lessonModuleService);

  final LessonMemberService? _lessonMemberService;

  @override
  List<String> get defaultIncludes => ['lesson', 'lessonMember', 'module'];

  /// Mark a lesson as finished by creating a LessonMember record.
  Future<void> finishLesson({required Map<String, dynamic> data}) async {
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
      await _lessonMemberService.create(data: data);
      emit(
        ResourceState.mutated(
          items: currentItems,
          operation: ResourceOperation.update,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }
}
