import 'package:app/enums/prf_soul_decision_type.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/models/remote/prf_soul_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_soul_state.dart';
part 'add_soul_cubit.freezed.dart';

class AddSoulCubit extends Cubit<AddSoulState> {
  AddSoulCubit({
    required SoulService soulService,
    required IsarService isarService,
  }) : super(const AddSoulState.initial()) {
    _soulService = soulService;
    _isarService = isarService;
  }

  late SoulService _soulService;
  late IsarService _isarService;

  Future<void> addSoul({
    required String missionUlid,
    required PRFClassGroup classGroup,
    required String fullName,
    required PRFSoulDecisionType decisionType,
    String? notes,
    String? admissionNumber,
  }) async {
    emit(const AddSoulState.loading());
    try {
      final soul = await _soulService.create(
        data: PRFSoulDTO(
          missionUlid: missionUlid,
          classGroupUlid: classGroup.ulid,
          fullName: fullName,
          admissionNumber: admissionNumber,
          decisionType: decisionType.apiKey,
          notes: notes,
        ).toJson(),
        includes: ['classGroup', 'mission'],
      );

      await _isarService.souls.persistEntities([soul]);
      emit(AddSoulState.loaded(soul: soul));
    } on Failure catch (e) {
      emit(AddSoulState.error(e.message));
    } catch (e) {
      emit(AddSoulState.error(e.toString()));
    }
  }
}
