import 'package:app/models/failure.dart';
import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_soul.dart';
import 'package:app/models/prf_soul_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/web.dart';

part 'add_soul_state.dart';
part 'add_soul_cubit.freezed.dart';

class AddSoulCubit extends Cubit<AddSoulState> {
  AddSoulCubit({
    required SoulService soulService,
    required HiveService hiveService,
  }) : super(const AddSoulState.initial()) {
    _soulService = soulService;
    _hiveService = hiveService;
  }

  late SoulService _soulService;
  late HiveService _hiveService;

  Future<void> addSoul({
    required String missionUlid,
    required PRFClassGroup classGroup,
    required String fullName,
  }) async {
    emit(const AddSoulState.loading());
    try {
      final localSoul = PRFSoul(
        'soulUlid',
        fullName,
        'dateTimestamp',
        'dateTimestamp',
        classGroup: classGroup,
      );
      _hiveService.persistSoul(localSoul, missionUlid);
      emit(AddSoulState.loaded(soul: localSoul));

      final soul = await _soulService.addSoul(
        soulDTO: PRFSoulDTO(
          missionUlid: missionUlid,
          classGroupUlid: classGroup.ulid,
          fullName: fullName,
        ),
      );
      Logger().d(soul);
    } on Failure catch (e) {
      emit(AddSoulState.error(e.message));
    } catch (e) {
      emit(AddSoulState.error(e.toString()));
    }
  }
}
