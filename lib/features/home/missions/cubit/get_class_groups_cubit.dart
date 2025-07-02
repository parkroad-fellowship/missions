import 'package:app/enums/prf_institution_type.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'get_class_groups_state.dart';
part 'get_class_groups_cubit.freezed.dart';

class GetClassGroupsCubit extends Cubit<GetClassGroupsState> {
  GetClassGroupsCubit({
    required SoulService soulService,
    required HiveService hiveService,
    required LocalDBService localDBService,
  }) : super(const GetClassGroupsState.initial()) {
    _soulService = soulService;
    _hiveService = hiveService;
    _localDBService = localDBService;
  }

  late SoulService _soulService;
  late HiveService _hiveService;
  late LocalDBService _localDBService;

  Future<void> getClassGroups({
    String? missionUlid,
  }) async {
    emit(const GetClassGroupsState.loading());
    try {
      final localClassGroups = _hiveService.retrieveClassGroups();
      if (localClassGroups.isNotEmpty) {
        if (missionUlid != null) {
          final mission = await _localDBService.loadMission(
            missionUlid: missionUlid,
          );
          Logger().d(mission.school);
          final filteredClassGroups = _filterClassGroupsByType(
            classGroups: localClassGroups,
            type: mission.school!.institutionType!,
          );
          emit(GetClassGroupsState.loaded(classGroups: filteredClassGroups));
          return;
        }
        emit(GetClassGroupsState.loaded(classGroups: localClassGroups));
        return;
      }

      final classGroups = await _soulService.getClassGroups();
      _hiveService.persistClassGroups(PRFClassGroupResponse(classGroups));

      if (missionUlid != null) {
        final mission = await _localDBService.loadMission(
          missionUlid: missionUlid,
        );
        final filteredClassGroups = _filterClassGroupsByType(
          classGroups: localClassGroups,
          type: mission.school!.institutionType!,
        );
        emit(GetClassGroupsState.loaded(classGroups: filteredClassGroups));
        return;
      }
      emit(GetClassGroupsState.loaded(classGroups: classGroups));
    } on Failure catch (e) {
      emit(GetClassGroupsState.error(e.message));
    } catch (e) {
      emit(GetClassGroupsState.error(e.toString()));
    }
  }

  List<PRFClassGroup> _filterClassGroupsByType({
    required List<PRFClassGroup> classGroups,
    required PRFInstitutionType type,
  }) {
    final filteredClassGroups = classGroups
        .where((classGroup) => classGroup.institutionType == type)
        .toList();
    return filteredClassGroups;
  }
}
