import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/prayer/prf_soul_dto.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_soul_state.dart';
part 'update_soul_cubit.freezed.dart';

class UpdateSoulCubit extends Cubit<UpdateSoulState> {
  UpdateSoulCubit({
    required SoulService soulService,
    required IsarService isarService,
  }) : super(const UpdateSoulState.initial()) {
    _soulService = soulService;
    _isarService = isarService;
  }

  late SoulService _soulService;
  late IsarService _isarService;

  Future<void> updateSoul({
    required String soulUlid,
    required String missionUlid,
    required String classGroupUlid,
    required String fullName,
    required int decisionType,
    String? notes,
    String? admissionNumber,
  }) async {
    emit(const UpdateSoulState.loading());
    try {
      final updatedSoul = await _soulService.update(
        id: soulUlid,
        data: PRFSoulDTO(
          missionUlid: missionUlid,
          classGroupUlid: classGroupUlid,
          fullName: fullName,
          decisionType: decisionType,
          notes: notes,
          admissionNumber: admissionNumber,
        ).toJson(),
        includes: ['classGroup', 'mission'],
      );

      await _isarService.souls.persistEntities([updatedSoul]);

      emit(const UpdateSoulState.loaded());
    } on Failure catch (e) {
      emit(UpdateSoulState.error(e.message));
    } catch (e) {
      emit(UpdateSoulState.error(e.toString()));
    }
  }
}
