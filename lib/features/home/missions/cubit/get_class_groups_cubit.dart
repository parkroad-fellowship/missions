import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_class_groups_state.dart';
part 'get_class_groups_cubit.freezed.dart';

class GetClassGroupsCubit extends Cubit<GetClassGroupsState> {
  GetClassGroupsCubit({
    required SoulService soulService,
    required HiveService hiveService,
  }) : super(const GetClassGroupsState.initial()) {
    _soulService = soulService;
    _hiveService = hiveService;
  }

  late SoulService _soulService;
  late HiveService _hiveService;

  Future<void> getClassGroups() async {
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

      final classGroups = await _soulService.getClassGroups();
      _hiveService.persistClassGroups(PRFClassGroupResponse(classGroups));
      emit(
        GetClassGroupsState.loaded(
          classGroups: classGroups,
        ),
      );
    } on Failure catch (e) {
      emit(GetClassGroupsState.error(e.message));
    } catch (e) {
      emit(GetClassGroupsState.error(e.toString()));
    }
  }
}
