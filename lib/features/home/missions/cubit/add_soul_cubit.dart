import 'package:app/enums/prf_soul_decision_type.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/models/remote/prf_soul_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_soul_state.dart';
part 'add_soul_cubit.freezed.dart';

class AddSoulCubit extends Cubit<AddSoulState> {
  AddSoulCubit({
    required SoulService soulService,
    required LocalDBService localDBService,
  }) : super(const AddSoulState.initial()) {
    _soulService = soulService;
    _localDBService = localDBService;
  }

  late SoulService _soulService;
  late LocalDBService _localDBService;

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
        includes: ['classGroup'],
      );

      await _localDBService.persistSouls(
        souls: [soul],
        missionUlid: missionUlid,
      );
      emit(AddSoulState.loaded(soul: soul));
    } on Failure catch (e) {
      emit(AddSoulState.error(e.message));
    } catch (e) {
      emit(AddSoulState.error(e.toString()));
    }
  }
}
