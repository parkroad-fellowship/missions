import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_courses_state.dart';
part 'get_courses_cubit.freezed.dart';

class GetCoursesCubit extends Cubit<GetCoursesState> {
  GetCoursesCubit({
    required CourseService courseService,
    required IsarService isarService,
    required HiveService hiveService,
  }) : super(const GetCoursesState.initial()) {
    _courseService = courseService;
    _isarService = isarService;
    _hiveService = hiveService;
  }

  late CourseService _courseService;
  late IsarService _isarService;
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
          'group_ulids': memberGroupUlids.join(','),
        },
      );

      await _isarService.courses.persistEntities(courses);
      await _isarService.courses.refreshStream();

      emit(GetCoursesState.loaded(isEmpty: courses.isEmpty));
    } catch (e) {
      emit(GetCoursesState.error(e.toString()));
    }
  }
}
