import 'package:app/services/api/lesson_module_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_lesson_modules_state.dart';
part 'get_lesson_modules_cubit.freezed.dart';

class GetLessonModulesCubit extends Cubit<GetLessonModulesState> {
  GetLessonModulesCubit({
    required LessonModuleService lessonModuleService,
    required IsarService isarService,
  }) : super(const GetLessonModulesState.initial()) {
    _lessonModuleService = lessonModuleService;
    _isarService = isarService;
  }

  late LessonModuleService _lessonModuleService;
  late IsarService _isarService;

  Future<void> getLessonModules({required String courseModuleUlid}) async {
    emit(const GetLessonModulesState.loading());

    try {
      final courseModule = await _isarService.courseModules.get(
        courseModuleUlid,
      );
      final localLessonModules = await _isarService.lessonModules
          .listParentLessons(courseModule!.moduleUlid);

      if (localLessonModules.isEmpty) {
        final lessonModules = await _lessonModuleService.list(
          filters: {
            'module_ulid': courseModule.moduleUlid,
          },
          includes: [
            'lesson',
            'lessonMember',
            'module',
          ],
        );

        await _isarService.lessonModules.persistEntities(lessonModules);
      }

      await _isarService.lessonModules.refreshParentStream(
        courseModule.moduleUlid,
      );

      emit(const GetLessonModulesState.loaded());
    } catch (e) {
      emit(GetLessonModulesState.error(e.toString()));
    }
  }
}
