import 'package:app/models/prf_class_group.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_class_groups_state.dart';
part 'get_class_groups_cubit.freezed.dart';

class GetClassGroupsCubit extends Cubit<GetClassGroupsState> {
  GetClassGroupsCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(const GetClassGroupsState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> getMissions() async {
    emit(const GetClassGroupsState.loading());
    try {
      final localClassGroups = _hiveService.retrieveClassGroups();
      if (localClassGroups.isNotEmpty) {
        emit(
          GetClassGroupsState.loaded(
            classGroups: localClassGroups,
          ),
        );
        return;
      }

      final classGroups = await _missionService.getClassGroups();
      _hiveService.persistClassGroups(PRFClassGroupResponse(classGroups));
      emit(
        GetClassGroupsState.loaded(
          classGroups: classGroups,
        ),
      );
    } catch (e) {
      emit(GetClassGroupsState.error(e.toString()));
    }
  }
}
