import 'package:app/services/_index.dart';
import 'package:app/services/api/course_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_courses_state.dart';
part 'get_courses_cubit.freezed.dart';

class GetCoursesCubit extends Cubit<GetCoursesState> {
  GetCoursesCubit({
    required CourseService courseService,
    required LocalDBService localDBService,
    required HiveService hiveService,
  }) : super(const GetCoursesState.initial()) {
    _courseService = courseService;
    _localDBService = localDBService;
    _hiveService = hiveService;
  }

  late CourseService _courseService;
  late LocalDBService _localDBService;
  late HiveService _hiveService;

  Future<void> getCourses() async {
    emit(const GetCoursesState.loading());

    try {
      final memberGroupUlids = _hiveService.retrieveMemberGroupUlids();

      final courses = await _courseService.list(
        includes: [
          'thumbnail',
          'courseMember',
        ],
        filters: {
          'filter[group_ulids]': memberGroupUlids.join(','),
        },
      );

      await _localDBService.persistCourses(courses: courses);

      emit(GetCoursesState.loaded(isEmpty: courses.isEmpty));
    } catch (e) {
      emit(GetCoursesState.error(e.toString()));
    }
  }
}
