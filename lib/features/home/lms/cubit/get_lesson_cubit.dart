import 'package:app/models/remote/failure.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_lesson_state.dart';
part 'get_lesson_cubit.freezed.dart';

class GetLessonCubit extends Cubit<GetLessonState> {
  GetLessonCubit({
    required IsarService isarService,
  }) : super(const GetLessonState.initial()) {
    _isarService = isarService;
  }

  late IsarService _isarService;

  Future<void> getLesson({
    required String lessonModuleId,
    bool refresh = false,
  }) async {
    try {
      emit(const GetLessonState.loading());

      await _isarService.lessonModules.refreshItemStream(lessonModuleId);

      emit(const GetLessonState.loaded());
    } on Failure catch (e) {
      emit(GetLessonState.error(e.message));
    } catch (e) {
      emit(GetLessonState.error(e.toString()));
    }
  }
}
