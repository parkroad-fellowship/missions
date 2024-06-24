import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_courses_state.dart';
part 'get_courses_cubit.freezed.dart';

class GetCoursesCubit extends Cubit<GetCoursesState> {
  GetCoursesCubit({
    required LMSService lmsService,
    required LocalDBService localDBService,
    required HiveService hiveService,
  }) : super(const GetCoursesState.initial()) {
    _lmsService = lmsService;
    _localDBService = localDBService;
    _hiveService = hiveService;
  }

  late LMSService _lmsService;
  late LocalDBService _localDBService;
  late HiveService _hiveService;

  Future<void> getCourses() async {
    emit(const GetCoursesState.loading());

    try {
      final memberGroupUlids = _hiveService.retrieveMemberGroupUlids();

      final courses = await _lmsService.getCourses(
        includes: 'thumbnail,courseMember',
        groups: memberGroupUlids ?? [],
      );

      await _localDBService.persistCourses(courses: courses);

      emit(GetCoursesState.loaded(isEmpty: courses.isEmpty));
    } catch (e) {
      emit(GetCoursesState.error(e.toString()));
    }
  }
}
