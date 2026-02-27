import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_course_cubit.freezed.dart';
part 'get_course_state.dart';

class GetCourseCubit extends Cubit<GetCourseState> {
  GetCourseCubit({
    required CourseService courseService,
    required IsarService isarService,
  }) : super(const GetCourseState.initial()) {
    _courseService = courseService;
    _isarService = isarService;
  }

  late CourseService _courseService;
  late IsarService _isarService;

  Future<void> getCourse({
    required String courseUlid,
    bool refresh = false,
  }) async {
    try {
      emit(const GetCourseState.loading());

      final localCourse = await _isarService.courses.get(courseUlid);
      if (localCourse == null || refresh) {
        final course = await _courseService.get(
          ulid: courseUlid,
          includes: [
            'thumbnail',
            'courseMember',
          ],
        );
        await _isarService.courses.persistEntity(course);
      }

      await _isarService.courses.refreshItemStream(courseUlid);

      emit(const GetCourseState.loaded());
    } on Failure catch (e) {
      emit(GetCourseState.error(e.message));
    } catch (e) {
      emit(GetCourseState.error(e.toString()));
    }
  }
}
